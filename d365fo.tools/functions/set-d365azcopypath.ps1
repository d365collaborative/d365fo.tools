
<#
    .SYNOPSIS
        Set the path for AzCopy.exe
        
    .DESCRIPTION
        Update the path where the module will be looking for the AzCopy.exe executable
        
    .PARAMETER Path
        Path to the AzCopy.exe
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallAzCopy -Path "C:\temp\d365fo.tools\AzCopy\AzCopy.exe"
        
        This will update the path for the AzCopy.exe in the modules configuration
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>
function Set-D365AzCopyPath {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

    if (Test-PSFFunctionInterrupt) { return }

    Set-PSFConfig -FullName "d365fo.tools.path.azcopy" -Value $Path
    Register-PSFConfig -FullName "d365fo.tools.path.azcopy"
    
    Update-ModuleVariables
}