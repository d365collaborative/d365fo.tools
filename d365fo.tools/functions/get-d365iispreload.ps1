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

    if (-not (Get-Module -ListAvailable -Name WebAdministration)) {
        Write-PSFMessage -Level Warning -Message "The 'WebAdministration' module is not installed. Please install it with: Install-WindowsFeature -Name Web-WebServer -IncludeManagementTools or Install-Module -Name WebAdministration -Scope CurrentUser"
        return
    }

    Import-Module WebAdministration -ErrorAction Stop

    $appPool = "AOSService"
    $site = "AOSService"

    $startMode = Get-ItemProperty "IIS:\AppPools\$appPool" -Name startMode
    $idleTimeout = (Get-ItemProperty "IIS:\AppPools\$appPool" -Name processModel.idleTimeout).Value
    $preloadEnabled = (Get-ItemProperty "IIS:\Sites\$site" -Name applicationDefaults.preloadEnabled).Value

    $doAppInitAfterRestart = $null
    try {
        $doAppInitAfterRestart = (Get-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "doAppInitAfterRestart" -location $site -ErrorAction Stop).Value
    } catch {
        $doAppInitAfterRestart = "Not available"
    }

    $preloadPage = $null
    try {
        $initPages = Get-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "." -location $site -ErrorAction Stop
        if ($initPages -and $initPages.Collection -and $initPages.Collection.Count -gt 0) {
            $preloadPage = $initPages.Collection[0].initializationPage
        } else {
            $preloadPage = "Not configured"
        }
    } catch {
        $preloadPage = "Not available"
    }

    [PSCustomObject]@{
        AppPool = $appPool
        StartMode = $startMode
        IdleTimeout = $idleTimeout
        Site = $site
        PreloadEnabled = $preloadEnabled
        DoAppInitAfterRestart = $doAppInitAfterRestart
        PreloadPage = $preloadPage
    }
}
