
<#
    .SYNOPSIS
        Get the compiler outputs presented
        
    .DESCRIPTION
        Get the compiler outputs presented in a structured manner on the screen
        
        It could be a Visual Studio compiler log or it could be a Invoke-D365ModuleCompile log you want analyzed
        
    .PARAMETER Path
        Path to the compiler log file that you want to work against
        
        A BuildModelResult.log or a Dynamics.AX.*.xppc.log file will both work
        
    .PARAMETER ErrorsOnly
        Instructs the cmdlet to only output compile results where there was errors detected
        
    .PARAMETER OutputTotals
        Instructs the cmdlet to output the total errors and warnings after the analysis
        
    .PARAMETER OutputAsObjects
        Instructs the cmdlet to output the objects instead of formatting them
        
        If you don't assign the output, it will be formatted the same way as the original output, but without the coloring of the column values
        
    .EXAMPLE
        PS C:\> Get-D365CompilerResult -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log"
        
        This will analyze the compiler log file for warning and errors.
        
        A result set example:
        
        File                                                                                    Warnings Errors
        ----                                                                                    -------- ------
        c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log                                        2      1
        
    .EXAMPLE
        PS C:\> Get-D365CompilerResult -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log" -ErrorsOnly
        
        This will analyze the compiler log file for warning and errors, but only output if it has errors.
        
        A result set example:
        
        File                                                                                    Warnings Errors
        ----                                                                                    -------- ------
        c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log                                        2      1
        
    .EXAMPLE
        PS C:\> Get-D365CompilerResult -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log" -ErrorsOnly -OutputAsObjects
        
        This will analyze the compiler log file for warning and errors, but only output if it has errors.
        The output will be PSObjects, which can be assigned to a variable and used for futher analysis.
        
        A result set example:
        
        File                                                                                    Warnings Errors
        ----                                                                                    -------- ------
        c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log                                        2      1
        
    .EXAMPLE
        PS C:\> Get-D365Module -Name *Custom* | Invoke-D365ModuleCompile | Get-D365CompilerResult -OutputTotals
        
        This will find all modules with Custom in their name.
        It will pass thoses modules into the Invoke-D365ModuleCompile, which will compile them.
        It will pass the paths to each compile output log to Get-D365CompilerResult, which will analyze them for warning and errors.
        It will output the total number of warning and errors found.
        
        File                                                                                    Warnings Errors
        ----                                                                                    -------- ------
        c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log                                        2      1
        
        Total Errors: 1
        Total Warnings: 2
        
    .NOTES
        Tags: Compiler, Build, Errors, Warnings, Tasks
        
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
function Get-D365CompilerResult {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    [OutputType('[PsCustomObject]')]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('LogFile')]
        [string] $Path,

        [switch] $ErrorsOnly,

        [switch] $OutputTotals,

        [switch] $OutputAsObjects
    )

    begin {
        Invoke-TimeSignal -Start
    
        $outputCollection = New-Object System.Collections.Generic.List[System.Object]
    }

    process {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        $res = Get-CompilerResult -Path $Path

        if ($null -ne $res) {
            $outputCollection.Add($res)
        }
    }

    end {
        
        $totalErrors = 0
        $totalWarnings = 0
    
        $resCol = @($outputCollection.ToArray())
        
        $totalWarnings = ($resCol | Measure-Object -Property Warnings -Sum).Sum
        $totalErrors = ($resCol | Measure-Object -Property Errors -Sum).Sum

        if($ErrorsOnly) {
            $resCol = @($resCol | Where-Object Errors -gt 0)
        }

        if($OutputAsObjects){
            $resCol
        }
        else {
            $resCol | format-table File, @{Label = "Warnings"; Expression = { $e = [char]27; $color = "93"; "$e[${color}m$($_.Warnings)${e}[0m" }; Align = 'right' }, @{Label = "Errors"; Expression = { $e = [char]27; $color = "91"; "$e[${color}m$($_.Errors)${e}[0m" }; Align = 'right' }
        }

        if ($OutputTotals) {
            Write-PSFHostColor -String "<c='Red'>Total Errors: $totalErrors</c>"
            Write-PSFHostColor -String "<c='Yellow'>Total Warnings: $totalWarnings</c>"
        }

        Invoke-TimeSignal -End
    }
}