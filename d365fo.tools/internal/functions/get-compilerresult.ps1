
<#
    .SYNOPSIS
        Parse the compiler output
        
    .DESCRIPTION
        Parse the output log files from the compiler and show the number of warnings and errors
        
    .PARAMETER Path
        The path to where the compiler output log file is located
        
        
    .EXAMPLE
        PS C:\> Get-CompilerResult -Path c:\temp\d365fo.tools\Dynamics.AX.Custom.xppc.log
        
        This will analaze the Dynamics.AX.Custom.xppc.log compiler output file.
        Will create a summarize object with number of errors and warnings.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet is inspired by the work of "Vilmos Kintera" (twitter: @DAXRunBase)
        
        All credits goes to him for showing how to extract these information
        
        His blog can be found here:
        https://www.daxrunbase.com/blog/
        
        The specific blog post that we based this cmdlet on can be found here:
        https://www.daxrunbase.com/2020/03/31/interpreting-compiler-results-in-d365fo-using-powershell/
        
        The github repository containing the original scrips can be found here:
        https://github.com/DAXRunBase/PowerShell-and-Azure
        
#>
function Get-CompilerResult {
    [CmdletBinding()]
    [OutputType('[PsCustomObject]')]
    param (
        [parameter(Mandatory = $true)]
        [string] $Path
    )

    Invoke-TimeSignal -Start

    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

    $errorText = Select-String -LiteralPath $Path -Pattern ^Errors: | ForEach-Object { $_.Line }
    $errorCount = [int]$errorText.Split()[-1]

    $warningText = Select-String -LiteralPath $Path -Pattern ^Warnings: | ForEach-Object { $_.Line }
    $warningCount = [int]$warningText.Split()[-1]

    [PsCustomObject][Ordered]@{
        File       = "$Path"
        Warnings   = $warningCount
        Errors     = $errorCount
        PSTypeName = 'D365FO.TOOLS.CompilerOutput'
    }
}