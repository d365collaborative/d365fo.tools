Write-Host "Installing Pester" -ForegroundColor Cyan
Install-Module Pester -Force -SkipPublisherCheck
Write-Host "Installing PSFramework" -ForegroundColor Cyan
Install-Module PSFramework -Force -SkipPublisherCheck
Write-Host "Installing PSScriptAnalyzer" -ForegroundColor Cyan
Install-Module PSScriptAnalyzer -Force -SkipPublisherCheck
Write-Host "Installing Azure.Storage" -ForegroundColor Cyan
Install-Module Azure.Storage -Force -SkipPublisherCheck
Write-Host "Installing AzureAd" -ForegroundColor Cyan
Install-Module AzureAd -Force -SkipPublisherCheck
Write-Host "Installing PSNotification" -ForegroundColor Cyan
Install-Module PSNotification -Force -SkipPublisherCheck
