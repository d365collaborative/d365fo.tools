
<#
    .SYNOPSIS
        Test if a given registry key exists or not
        
    .DESCRIPTION
        Test if a given registry key exists in the path specified
        
    .PARAMETER Path
        Path to the registry hive and sub directories you want to work against
        
    .PARAMETER Name
        Name of the registry key that you want to test for
        
    .EXAMPLE
        PS C:\> Test-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Dynamics\Deployment\" -Name "InstallationInfoDirectory"
        
        This will query the LocalMachine hive and the sub directories "HKLM:\SOFTWARE\Microsoft\Dynamics\Deployment\" for a registry key with the name of "InstallationInfoDirectory".
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
Function Test-RegistryValue {
    [OutputType('System.Boolean')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (Test-Path -Path $Path -PathType Any) {
        $null -ne (Get-ItemProperty $Path).$Name
    }
    else {
        $false
    }
}