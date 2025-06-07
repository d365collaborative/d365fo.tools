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
    param ()
    Import-Module WebAdministration -ErrorAction Stop
    $appPool = "AOSService"
    $site = "AOSService"
    # Set Application Pool to AlwaysRunning and Idle Time-out to 0
    Set-ItemProperty "IIS:\AppPools\$appPool" -Name startMode -Value AlwaysRunning
    Set-ItemProperty "IIS:\AppPools\$appPool" -Name processModel.idleTimeout -Value ([TimeSpan]::Zero)
    # Enable Preload on the website
    Set-ItemProperty "IIS:\Sites\$site" -Name applicationDefaults.preloadEnabled -Value $true
    # Try to set doAppInitAfterRestart if Application Initialization is installed
    try {
        Set-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -filter "system.webServer/applicationInitialization" -name "doAppInitAfterRestart" -value "True" -location $site -ErrorAction Stop
    } catch {
        Write-Verbose "Application Initialization not installed or not available. Skipping doAppInitAfterRestart."
    }
    Write-Host "IIS Preload enabled for $site."
}
