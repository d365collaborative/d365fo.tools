Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

$modules = @("Pester", "PSFramework", "PSScriptAnalyzer", "Azure.Storage", "AzureAd", "PSNotification")

foreach ($module in $modules) {
    Write-Host "Installing $module" -ForegroundColor Cyan
    Install-Module $module -Force -SkipPublisherCheck -Scope AllUsers
    Import-Module $module -Force -PassThru
}

(Get-Module -ListAvailable).ModuleBase