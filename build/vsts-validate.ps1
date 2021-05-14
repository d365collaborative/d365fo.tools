param (
    $TestGeneral = $true,
	
    $TestFunctions = $true,

    $TestScriptAnalyzer = $true
)

# Guide for available variables and working with secrets:
# https://docs.microsoft.com/en-us/vsts/build-release/concepts/definitions/build/variables?tabs=powershell

# Needs to ensure things are Done Right and only legal commits to master get built

# Run internal pester tests

Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

$modules = @("PSFramework", "PSScriptAnalyzer", "Azure.Storage", "AzureAd", "PSNotification")

foreach ($module in $modules) {
    $module = Get-Module -Name $module -ErrorAction SilentlyContinue

    if ($null -eq $module) {
        Write-Host "Importing $module" -ForegroundColor Cyan
        Import-Module $module -Force
    }
}

Import-Module "Pester" -MaximumVersion 4.99.99 -Force

& "$PSScriptRoot\..\d365fo.tools\tests\pester.ps1" -TestGeneral $TestGeneral -TestFunctions $TestFunctions -TestScriptAnalyzer $TestScriptAnalyzer