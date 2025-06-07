<#
    .SYNOPSIS
        Disables IIS Preload for the AOSService application pool and website.
    .DESCRIPTION
        Reverts IIS Preload settings for the AOSService application:
        - Sets Application Pool Start Mode to OnDemand
        - Sets Idle Time-out to 20 minutes (default)
        - Disables Preload on the AOSService website
        - Sets doAppInitAfterRestart to false (if Application Initialization is installed)
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

    # Set Application Pool to OnDemand and Idle Time-out to 20 minutes
    Set-ItemProperty "IIS:\AppPools\$appPool" -Name startMode -Value OnDemand
    Set-ItemProperty "IIS:\AppPools\$appPool" -Name processModel.idleTimeout -Value ([TimeSpan]::FromMinutes(20))

    # Disable Preload on the website
    Set-ItemProperty "IIS:\Sites\$site" -Name applicationDefaults.preloadEnabled -Value $false

    # Try to set doAppInitAfterRestart if Application Initialization is installed
    try {
        Set-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "doAppInitAfterRestart" -value "False" -location $site -ErrorAction Stop
    } catch {
        Write-Verbose "Application Initialization not installed or not available. Skipping doAppInitAfterRestart."
    }

    Write-Host "IIS Preload disabled for $site."
}
