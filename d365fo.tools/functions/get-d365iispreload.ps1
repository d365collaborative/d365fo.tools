<#
    .SYNOPSIS
        Gets IIS Preload status for the AOSService application pool and website.
    .DESCRIPTION
        Returns the current IIS Preload configuration for the AOSService application:
        - Application Pool Start Mode
        - Idle Time-out
        - Website Preload Enabled
        - doAppInitAfterRestart (if Application Initialization is installed)
    .EXAMPLE
        Get-D365IISPreload
    .NOTES
        Author: Copilot (based on Denis Trunin's article)
#>
function Get-D365IISPreload {
    [CmdletBinding()]
    param ()
    Import-Module WebAdministration -ErrorAction Stop
    $appPool = "AOSService"
    $site = "AOSService"
    $startMode = (Get-ItemProperty "IIS:\AppPools\$appPool" -Name startMode).startMode
    $idleTimeout = (Get-ItemProperty "IIS:\AppPools\$appPool" -Name processModel.idleTimeout)."processModel.idleTimeout"
    $preloadEnabled = (Get-ItemProperty "IIS:\Sites\$site" -Name applicationDefaults.preloadEnabled)."applicationDefaults.preloadEnabled"
    $doAppInitAfterRestart = $null
    try {
        $doAppInitAfterRestart = (Get-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "doAppInitAfterRestart" -location $site -ErrorAction Stop).Value
    } catch {
        $doAppInitAfterRestart = "Not available"
    }
    [PSCustomObject]@{
        AppPool = $appPool
        StartMode = $startMode
        IdleTimeout = $idleTimeout
        Site = $site
        PreloadEnabled = $preloadEnabled
        DoAppInitAfterRestart = $doAppInitAfterRestart
    }
}
