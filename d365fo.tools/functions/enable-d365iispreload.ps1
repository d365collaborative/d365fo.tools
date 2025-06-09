<#
    .SYNOPSIS
        Enables IIS Preload for the AOSService application pool and website.
    .DESCRIPTION
        Configures IIS to preload the AOSService application, improving startup time after X++ compile.
        - Sets Application Pool Start Mode to AlwaysRunning
        - Sets Idle Time-out to 0
        - Enables Preload on the AOSService website
        - Sets doAppInitAfterRestart to true (if Application Initialization is installed)
        - Optionally sets the initializationPage to a custom base URL
    .PARAMETER BaseUrl
        The base URL to use for the initializationPage setting in IIS Application Initialization.
        If not provided, the function will attempt to determine the base URL automatically using Get-D365Url.
        Example: https://usnconeboxax1aos.cloud.onebox.dynamics.com
    .EXAMPLE
        Enable-D365IISPreload
        This will enable IIS Preload and set the initializationPage using the automatically detected base URL.
    .EXAMPLE
        Enable-D365IISPreload -BaseUrl "https://usnconeboxax1aos.cloud.onebox.dynamics.com"
        This will enable IIS Preload and set the initializationPage to https://usnconeboxax1aos.cloud.onebox.dynamics.com/?mi=DefaultDashboard
    .NOTES
        Author: Florian Hopfner (FH-Inway)
        Based on Denis Trunin's article "Enable IIS Preload to Speed Up Restart After X++ Compile" (https://www.linkedin.com/pulse/enable-iis-preload-speed-up-restart-after-x-compile-denis-trunin-86j5c)
        Written with GitHub Copilot GPT-4.1, mostly in agent mode. See commits for prompts.
#>
function Enable-D365IISPreload {
    [CmdletBinding()]
    param (
        [string]$BaseUrl = ""
    )

    
    if (-not (Get-Module -ListAvailable -Name WebAdministration)) {
        Write-PSFMessage -Level Warning -Message "The 'WebAdministration' module is not installed. Please install it with: Install-WindowsFeature -Name Web-WebServer -IncludeManagementTools or Install-Module -Name WebAdministration -Scope CurrentUser"
        return
    }
    
    Import-Module WebAdministration -ErrorAction Stop
    
    # Backup IIS Preload configuration before making changes
    $backupDir = Join-Path $Script:DefaultTempPath "IISConfigBackup"
    if (-not (Test-Path $backupDir)) {
        New-Item -Path $backupDir -ItemType Directory | Out-Null
    }
    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $iisConfigBackupFile = Join-Path $backupDir ("IISPreloadConfig.$timestamp.json")
    $preloadConfig = Get-D365IISPreload | ConvertTo-Json -Depth 5
    $preloadConfig | Out-File -FilePath $iisConfigBackupFile -Encoding UTF8
    Write-PSFMessage -Level Host -Message "IIS Preload configuration backed up to $iisConfigBackupFile"
    
    # Ensure IIS Application Initialization feature is installed
    $iisAppInitFeature = Get-WindowsFeature -Name Web-AppInit -ErrorAction SilentlyContinue
    if (-not ($iisAppInitFeature -and $iisAppInitFeature.Installed)) {
        Write-PSFMessage -Level Host -Message "IIS Application Initialization (Web-AppInit) feature is not installed. Installing..."
        Install-WindowsFeature -Name Web-AppInit -IncludeAllSubFeature -IncludeManagementTools -ErrorAction Stop | Out-Null
        Write-PSFMessage -Level Host -Message "IIS Application Initialization feature installed."
    }
    
    $appPool = "AOSService"
    $site = "AOSService"

    # Set Application Pool to AlwaysRunning and Idle Time-out to 0
    $setAppPoolStartModeParams = @{
        Path  = "IIS:\AppPools\$appPool"
        Name  = 'startMode'
        Value = 'AlwaysRunning'
    }
    Write-PSFMessage -Level Verbose -Message "Setting Application Pool '$appPool' startMode to 'AlwaysRunning'"
    Set-ItemProperty @setAppPoolStartModeParams
    $setAppPoolIdleTimeoutParams = @{
        Path  = "IIS:\AppPools\$appPool"
        Name  = 'processModel.idleTimeout'
        Value = ([TimeSpan]::Zero)
    }
    Write-PSFMessage -Level Verbose -Message "Setting Application Pool '$appPool' idleTimeout to '0'"
    Set-ItemProperty @setAppPoolIdleTimeoutParams

    # Enable Preload on the website
    $setSitePreloadParams = @{
        Path  = "IIS:\Sites\$site"
        Name  = 'applicationDefaults.preloadEnabled'
        Value = $true
    }
    Write-PSFMessage -Level Verbose -Message "Setting Site '$site' applicationDefaults.preloadEnabled to 'True'"
    Set-ItemProperty @setSitePreloadParams

    if (-not $BaseUrl) {
        try {
            $baseUrlObj = Get-D365Url
            if ($baseUrlObj -and $baseUrlObj.Url) {
                $BaseUrl = $baseUrlObj.Url.TrimEnd('/')
            }
        } catch {
            Write-PSFMessage -Level Verbose -Message "Could not determine base URL using Get-D365Url. Defaulting to root."
            $BaseUrl = ""
        }
    }

    # Set the initializationPage for application initialization
    try {
        $initPage = if ($BaseUrl) { "$BaseUrl/?mi=DefaultDashboard" } else { "/?mi=DefaultDashboard" }
        Write-PSFMessage -Level Verbose -Message "Setting Site '$site' initializationPage to '$initPage'"
        $addInitPageParams = @{
            pspath      = "MACHINE/WEBROOT/APPHOST/$site"
            filter      = 'system.webServer/applicationInitialization'
            name        = '.'
            value       = @{ initializationPage = $initPage }
            ErrorAction = 'Stop'
        }
        Add-WebConfigurationProperty @addInitPageParams
    } catch {
        Write-PSFMessage -Level Verbose -Message "Preload page $initPage cannot be set. Application Initialization may not be installed or not available. Skipping initializationPage."
    }

    # Try to set doAppInitAfterRestart if Application Initialization is installed
    try {
        $setDoAppInitParams = @{
            pspath      = "MACHINE/WEBROOT/APPHOST/$site"
            filter      = 'system.webServer/applicationInitialization'
            name        = 'doAppInitAfterRestart'
            value       = 'True'
            ErrorAction = 'Stop'
        }
        Write-PSFMessage -Level Verbose -Message "Setting Site '$site' doAppInitAfterRestart to 'True'"
        Set-WebConfigurationProperty @setDoAppInitParams
    } catch {
        Write-PSFMessage -Level Verbose -Message "doAppInitAfterRestart cannot be set. Application Initialization may not be installed or not available. Skipping doAppInitAfterRestart."
    }

    Write-PSFMessage -Level Host -Message "IIS Preload enabled for $site."
}
