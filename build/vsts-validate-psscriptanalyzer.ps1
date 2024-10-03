param (
    $TestPublic = $true,
	
    $TestInternal = $true
)

# Guide for available variables and working with secrets:
# https://docs.microsoft.com/en-us/vsts/build-release/concepts/definitions/build/variables?tabs=powershell

# Needs to ensure things are Done Right and only legal commits to master get built

# Run internal pester tests

Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

$modules = @("PSFramework", "PSScriptAnalyzer", "Az.Storage", "PSOAuthHelper", "ImportExcel")

foreach ($item in $modules) {
    $module = Get-Module -Name $item -ErrorAction SilentlyContinue

    if ($null -eq $module) {
        Write-Host "Importing $item" -ForegroundColor Cyan
        Import-Module $item -Force
    }
}

Import-Module "Pester" -MaximumVersion 4.99.99 -Force

& "$PSScriptRoot\..\d365fo.tools\tests\pester-PSScriptAnalyzer.ps1" -TestPublic $TestPublic -TestInternal $TestInternal