# Installs the modules required for the automatic text generation.
# See also https://github.com/d365collaborative/d365fo.tools/wiki/Building-tools

Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

$modules = @("PSModuleDevelopment", "platyPS")

foreach ($item in $modules) {
    
    $module = Get-InstalledModule -Name $item -ErrorAction SilentlyContinue

    if ($null -eq $module) {
        Write-Host "Installing $item" -ForegroundColor Cyan
        Install-Module -Name $item -Force -Confirm:$false -Scope CurrentUser -AllowClobber -SkipPublisherCheck
    }
    
    Import-Module $item -Force
    Get-Module -Name $item
}