<#
    .SYNOPSIS
        Disables IIS Preload for the AOSService application pool and website.
    .DESCRIPTION
        Reverts IIS Preload settings for the AOSService application:
        - Sets Application Pool Start Mode to OnDemand
        - Sets Idle Time-out to 0 (default)
        - Disables Preload on the AOSService website
        - Sets doAppInitAfterRestart to false (if Application Initialization is installed)
        - Restores previous IIS Preload configuration from backup if available
        - Restores or removes the initializationPage property as appropriate
    .EXAMPLE
        Disable-D365IISPreload
    .NOTES
        Author: Copilot (based on Denis Trunin's article)
#>
function Disable-D365IISPreload {
    [CmdletBinding()]
    param ()

    if (-not (Get-Module -ListAvailable -Name WebAdministration)) {
        Write-Host "The 'WebAdministration' module is not installed. Please install it with: Install-WindowsFeature -Name Web-WebServer -IncludeManagementTools or Install-Module -Name WebAdministration -Scope CurrentUser"
        return
    }

    Import-Module WebAdministration -ErrorAction Stop

    $appPool = "AOSService"
    $site = "AOSService"

    # Set default values first
    $startMode = 'OnDemand'
    $idleTimeout = [TimeSpan]::Zero
    $preloadEnabled = $false
    $doAppInitAfterRestart = 'False'
    $preloadPage = $null

    # Try to restore previous IIS Preload configuration from backup if available
    $backupDir = Join-Path $Script:DefaultTempPath "IISConfigBackup"
    $backupFile = $null
    if (Test-Path $backupDir) {
        $backupFiles = Get-ChildItem -Path $backupDir -Filter 'IISPreloadConfig.*.json' | Sort-Object LastWriteTime -Descending
        if ($backupFiles) {
            $backupFile = $backupFiles[0].FullName
        }
    }
    if ($backupFile) {
        Write-Host "Restoring IIS Preload configuration from backup: $backupFile"
        $preloadConfig = Get-Content $backupFile | ConvertFrom-Json
        if ($preloadConfig.StartMode) { $startMode = $preloadConfig.StartMode }
        if ($preloadConfig.IdleTimeout) { $idleTimeout = $preloadConfig.IdleTimeout }
        if ($null -ne $preloadConfig.PreloadEnabled) { $preloadEnabled = $preloadConfig.PreloadEnabled }
        if ($preloadConfig.DoAppInitAfterRestart) { $doAppInitAfterRestart = $preloadConfig.DoAppInitAfterRestart }
        if ($preloadConfig.PreloadPage) { $preloadPage = $preloadConfig.PreloadPage }
    }

    # Set Application Pool Start Mode and Idle Time-out
    Set-ItemProperty "IIS:\AppPools\$appPool" -Name startMode -Value $startMode
    Set-ItemProperty "IIS:\AppPools\$appPool" -Name processModel.idleTimeout -Value $idleTimeout

    # Set Preload on the website
    Set-ItemProperty "IIS:\Sites\$site" -Name applicationDefaults.preloadEnabled -Value $preloadEnabled

    # Set doAppInitAfterRestart if Application Initialization is installed
    try {
        Set-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "doAppInitAfterRestart" -value $doAppInitAfterRestart -location $site -ErrorAction Stop
    } catch {
        Write-Verbose "Application Initialization not installed or not available. Skipping doAppInitAfterRestart."
    }

    # Restore or remove the initializationPage if Application Initialization is installed
    try {
        if ($preloadPage -and $preloadPage -ne 'Not available' -and $preloadPage -ne 'Not configured') {
            Set-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "initializationPage" -value $preloadPage -location $site -ErrorAction Stop
        } else {
            Clear-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "initializationPage" -location $site -ErrorAction Stop
        }
    } catch {
        Write-Verbose "Application Initialization not installed or not available. Skipping initializationPage restore/removal."
    }

    Write-Host "IIS Preload disabled for $site."
}
