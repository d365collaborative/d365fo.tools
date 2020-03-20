
<#
    .SYNOPSIS
        Set the path for SqlPackage.exe
        
    .DESCRIPTION
        Update the path where the module will be looking for the SqlPackage.exe executable
        
    .PARAMETER Path
        Path to the SqlPackage.exe
        
    .EXAMPLE
        PS C:\> Set-D365SqlPackagePath -Path "C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe"
        
        This will update the path for the SqlPackage.exe in the modules configuration
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Set-D365SqlPackagePath {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

    if (Test-PSFFunctionInterrupt) { return }

    Set-PSFConfig -FullName "d365fo.tools.path.sqlpackage" -Value $Path
    Register-PSFConfig -FullName "d365fo.tools.path.sqlpackage"

    Update-ModuleVariables
}