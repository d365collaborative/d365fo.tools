Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

# $modules = @("PSFramework", "Azure.Storage", "AzureAd", "PSNotification", "PSOAuthHelper", "PowerShellGet", "PackageManagement","ImportExcel","PSScriptAnalyzer")
$modules = @("PSFramework", "PSScriptAnalyzer", "Azure.Storage", "AzureAd", "PSNotification", "PSOAuthHelper", "ImportExcel")

Install-Module "Pester" -MaximumVersion 4.99.99 -Force -SkipPublisherCheck -AllowClobber

."$PSScriptRoot\install-modulefast.ps1"
Install-Modulefast -ModulesToInstall $modules