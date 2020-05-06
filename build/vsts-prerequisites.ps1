Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

$modules = @("Pester", "PSFramework", "Azure.Storage", "AzureAd", "PSNotification", "PSOAuthHelper", "PowerShellGet", "PackageManagement","ImportExcel")

Install-Module -Name "PSScriptAnalyzer" -Force -SkipPublisherCheck -AllowClobber -RequiredVersion 1.18.3

foreach ($module in $modules) {
    Write-Host "Installing $module" -ForegroundColor Cyan
    Install-Module $module -Force -SkipPublisherCheck -AllowClobber
    Import-Module $module -Force -PassThru
}

#(Get-Module -ListAvailable).ModuleBase