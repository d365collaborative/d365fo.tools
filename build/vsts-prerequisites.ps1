Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

$modules = @("PSFramework", "Azure.Storage", "AzureAd", "PSNotification", "PSOAuthHelper", "PowerShellGet", "PackageManagement","ImportExcel","PSScriptAnalyzer")

Install-Module "Pester" -MaximumVersion 4.99.99
#Install-Module -Name "PSScriptAnalyzer" -Force -SkipPublisherCheck -AllowClobber #-RequiredVersion 1.18.3

foreach ($module in $modules) {
    Write-Host "Installing $module" -ForegroundColor Cyan
    Install-Module $module -Force -SkipPublisherCheck -AllowClobber
    Import-Module $module -Force -PassThru
}

#(Get-Module -ListAvailable).ModuleBase