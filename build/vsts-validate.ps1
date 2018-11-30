# Guide for available variables and working with secrets:
# https://docs.microsoft.com/en-us/vsts/build-release/concepts/definitions/build/variables?tabs=powershell

# Needs to ensure things are Done Right and only legal commits to master get built

# Run internal pester tests

Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

$modules = @("Pester", "PSFramework", "PSScriptAnalyzer", "Azure.Storage", "AzureAd", "PSNotification")

foreach ($module in $modules) {
    Write-Host "Importing $module" -ForegroundColor Cyan
    Import-Module $module -Force -PassThru
}

(Get-Module -ListAvailable).ModuleBase

& "$PSScriptRoot\..\d365fo.tools\tests\pester.ps1"