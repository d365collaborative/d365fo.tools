
<#
    .SYNOPSIS
        Set the path for nuget.exe
        
    .DESCRIPTION
        Update the path where the module will be looking for the nuget.exe executable
        
    .PARAMETER Path
        Path to the nuget.exe
        
    .EXAMPLE
        PS C:\> Set-D365NugetPath -Path "C:\temp\d365fo.tools\nuget\nuget.exe"
        
        This will update the path for the nuget.exe in the modules configuration
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>
function Set-D365NugetPath {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

    if (Test-PSFFunctionInterrupt) { return }

    Set-PSFConfig -FullName "d365fo.tools.path.nuget" -Value $Path
    Register-PSFConfig -FullName "d365fo.tools.path.nuget"

    Update-ModuleVariables
}