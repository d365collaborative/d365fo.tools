<#
    .SYNOPSIS
        Enables IIS Preload for the AOSService application pool and website.
    .DESCRIPTION
        Configures IIS to preload the AOSService application, improving startup time after X++ compile.
        - Sets Application Pool Start Mode to AlwaysRunning
        - Sets Idle Time-out to 0
        - Enables Preload on the AOSService website
        - Sets doAppInitAfterRestart to true (if Application Initialization is installed)
    .EXAMPLE
        Enable-D365IISPreload
    .NOTES
        Author: Copilot (based on Denis Trunin's article)
#>
function Enable-D365IISPreload {
    [CmdletBinding()]
    param (
        [string]$BaseUrl = ""
    )

    if (-not (Get-Module -ListAvailable -Name WebAdministration)) {
        Write-Host "The 'WebAdministration' module is not installed. Please install it with: Install-WindowsFeature -Name Web-WebServer -IncludeManagementTools or Install-Module -Name WebAdministration -Scope CurrentUser"
        return
    }

    Import-Module WebAdministration -ErrorAction Stop

    $appPool = "AOSService"
    $site = "AOSService"

    # Set Application Pool to AlwaysRunning and Idle Time-out to 0
    Set-ItemProperty "IIS:\AppPools\$appPool" -Name startMode -Value AlwaysRunning
    Set-ItemProperty "IIS:\AppPools\$appPool" -Name processModel.idleTimeout -Value ([TimeSpan]::Zero)

    # Enable Preload on the website
    Set-ItemProperty "IIS:\Sites\$site" -Name applicationDefaults.preloadEnabled -Value $true

    if (-not $BaseUrl) {
        try {
            $baseUrlObj = Get-D365Url
            if ($baseUrlObj -and $baseUrlObj.Url) {
                $BaseUrl = $baseUrlObj.Url.TrimEnd('/')
            }
        } catch {
            Write-Verbose "Could not determine base URL using Get-D365Url. Defaulting to root."
            $BaseUrl = ""
        }
    }

    # Set the initializationPage for application initialization
    try {
        $initPage = if ($BaseUrl) { "$BaseUrl/?mi=DefaultDashboard" } else { "/?mi=DefaultDashboard" }
        Set-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "initializationPage" -value $initPage -location $site -ErrorAction Stop
    } catch {
        Write-Verbose "Application Initialization not installed or not available. Skipping initializationPage."
    }

    # Try to set doAppInitAfterRestart if Application Initialization is installed
    try {
        Set-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "doAppInitAfterRestart" -value "True" -location $site -ErrorAction Stop
    } catch {
        Write-Verbose "Application Initialization not installed or not available. Skipping doAppInitAfterRestart."
    }

    Write-Host "IIS Preload enabled for $site."
}
