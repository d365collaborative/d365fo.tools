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
        - Uninstalls IIS Application Initialization feature if it was not installed in the backup

    .EXAMPLE
        PS C:\> Disable-D365IISPreload

        Disables IIS Preload for the AOSService application pool and website, restoring previous settings from backup if available.

    .NOTES
        Author: Florian Hopfner (FH-Inway)
        Based on Denis Trunin's article "Enable IIS Preload to Speed Up Restart After X++ Compile" (https://www.linkedin.com/pulse/enable-iis-preload-speed-up-restart-after-x-compile-denis-trunin-86j5c)
        Written with GitHub Copilot GPT-4.1, mostly in agent mode. See commits for prompts.

    .LINK
        Get-D365IISPreload

    .LINK
        Enable-D365IISPreload
#>
function Disable-D365IISPreload {
    [CmdletBinding()]
    param ()

    if (-not (Get-Module -ListAvailable -Name WebAdministration)) {
        Write-PSFMessage -Level Warning -Message "The 'WebAdministration' module is not installed. Please install it with: Install-WindowsFeature -Name Web-WebServer -IncludeManagementTools or Install-Module -Name WebAdministration -Scope CurrentUser"
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
        Write-PSFMessage -Level Host -Message "Restoring IIS Preload configuration from backup: $backupFile"
        $preloadConfig = Get-Content $backupFile | ConvertFrom-Json
        if ($preloadConfig.StartMode) { $startMode = $preloadConfig.StartMode }
        if ($preloadConfig.IdleTimeout) { $idleTimeout = $preloadConfig.IdleTimeout }
        if ($null -ne $preloadConfig.PreloadEnabled) { $preloadEnabled = $preloadConfig.PreloadEnabled }
        if ($preloadConfig.DoAppInitAfterRestart) { $doAppInitAfterRestart = $preloadConfig.DoAppInitAfterRestart }
        if ($preloadConfig.PreloadPage) { $preloadPage = $preloadConfig.PreloadPage }
        # Uninstall IIS Application Initialization feature if it was not installed in the backup
        if ($preloadConfig.IISApplicationInitFeature -eq 'Not installed') {
            Write-PSFMessage -Level Host -Message "Uninstalling IIS Application Initialization feature (Web-AppInit) as per backup state."
            try {
                Uninstall-WindowsFeature -Name Web-AppInit -Confirm:$false | Out-Null
            } catch {
                Write-PSFMessage -Level Warning -Message "Failed to uninstall IIS Application Initialization feature. $_"
            }
        }
    }

    # Set Application Pool Start Mode and Idle Time-out
    $setAppPoolStartModeParams = @{
        Path  = "IIS:\AppPools\$appPool"
        Name  = 'startMode'
        Value = $startMode
    }
    Write-PSFMessage -Level Verbose -Message "Setting Application Pool '$appPool' startMode to '$startMode'"
    Set-ItemProperty @setAppPoolStartModeParams
    $setAppPoolIdleTimeoutParams = @{
        Path  = "IIS:\AppPools\$appPool"
        Name  = 'processModel.idleTimeout'
        Value = $idleTimeout
    }
    Write-PSFMessage -Level Verbose -Message "Setting Application Pool '$appPool' idleTimeout to '$idleTimeout'"
    Set-ItemProperty @setAppPoolIdleTimeoutParams
    $setSitePreloadParams = @{
        Path  = "IIS:\Sites\$site"
        Name  = 'applicationDefaults.preloadEnabled'
        Value = $preloadEnabled
    }
    Write-PSFMessage -Level Verbose -Message "Setting Site '$site' applicationDefaults.preloadEnabled to '$preloadEnabled'"
    Set-ItemProperty @setSitePreloadParams
    try {
        $setDoAppInitParams = @{
            pspath      = "MACHINE/WEBROOT/APPHOST/$site"
            filter      = 'system.webServer/applicationInitialization'
            name        = 'doAppInitAfterRestart'
            value       = $doAppInitAfterRestart
            ErrorAction = 'Stop'
        }
        Write-PSFMessage -Level Verbose -Message "Setting Site '$site' doAppInitAfterRestart to '$doAppInitAfterRestart'"
        Set-WebConfigurationProperty @setDoAppInitParams
    } catch {
        Write-PSFMessage -Level Verbose -Message "Application Initialization not installed or not available. Skipping doAppInitAfterRestart."
    }

    # Reset or remove initializationPage setting
    $getInitPagesParams = @{
        pspath      = 'MACHINE/WEBROOT/APPHOST'
        filter      = 'system.webServer/applicationInitialization'
        name        = '.'
        location    = $site
        ErrorAction = 'Stop'
    }
    $initPages = Get-WebConfigurationProperty @getInitPagesParams
    if ($initPages -and $initPages.Collection -and $initPages.Collection.Count -gt 0) {
        $currentPreloadPage = $initPages.Collection[0].initializationPage
    }
    if ($currentPreloadPage) {
        if ($preloadPage -and $preloadPage -ne "Not configured" -and $preloadPage -ne "Not available") {
            try {
                Write-PSFMessage -Level Verbose -Message "Setting Site '$site' initializationPage to '$preloadPage'"
                $setInitPageParams = @{
                    pspath      = "MACHINE/WEBROOT/APPHOST/$site"
                    filter      = 'system.webServer/applicationInitialization'
                    name        = '.'
                    value       = @{ initializationPage = $preloadPage }
                    AtElement   = @{ initializationPage = $currentPreloadPage }
                    ErrorAction = 'Stop'
                }
                Set-WebConfigurationProperty @setInitPageParams
            } catch {
                Write-PSFMessage -Level Verbose -Message "Preload page $preloadPage cannot be set. Application Initialization may not be installed or not available. Skipping initializationPage."
            }
        } else {
            try {
                Write-PSFMessage -Level Verbose -Message "Removing initializationPage from Site '$site'"
                if ($currentPreloadPage) {
                    $removeInitPageParams = @{
                        pspath      = "MACHINE/WEBROOT/APPHOST/$site"
                        filter      = 'system.webServer/applicationInitialization'
                        name        = '.'
                        AtElement   = @{ initializationPage = $currentPreloadPage }
                        ErrorAction = 'Stop'
                    }
                    Remove-WebConfigurationProperty @removeInitPageParams
                }
            } catch {
                Write-PSFMessage -Level Verbose -Message "Failed to remove initializationPage from Site '$site'. It may not exist."
            }
        }
    }
    
    Write-PSFMessage -Level Host -Message "IIS Preload disabled for $site."
}
