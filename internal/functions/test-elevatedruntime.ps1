
function Test-ElevatedRunTime
{
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Throw "The script needs to be run under an elevated PowerShell console"

    }
}