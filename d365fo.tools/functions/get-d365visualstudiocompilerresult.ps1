
<#
    .SYNOPSIS
        Get the compiler outputs presented
        
    .DESCRIPTION
        Get the Visual Studio compiler outputs presented in a structured manner on the screen
        
    .PARAMETER Module
        Name of the module that you want to work against
        
        Default value is "*" which will search for all modules
        
    .PARAMETER ErrorsOnly
        Instructs the cmdlet to only output compile results where there was errors detected
        
    .PARAMETER OutputTotals
        Instructs the cmdlet to output the total errors and warnings after the analysis
        
    .PARAMETER OutputAsObjects
        Instructs the cmdlet to output the objects instead of formatting them
        
        If you don't assign the output, it will be formatted the same way as the original output, but without the coloring of the column values
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Default path is the same as the AOS service "PackagesLocalDirectory" directory
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-D365VisualStudioCompilerResult
        
        This will return the compiler output for all modules.
        
        A result set example:
        
        File                                                                                     Warnings Errors
        ----                                                                                     -------- ------
        K:\AosService\PackagesLocalDirectory\ApplicationCommon\BuildModelResult.log                    55      0
        K:\AosService\PackagesLocalDirectory\ApplicationFoundation\BuildModelResult.log               692      0
        K:\AosService\PackagesLocalDirectory\ApplicationPlatform\BuildModelResult.log                 155      0
        K:\AosService\PackagesLocalDirectory\ApplicationSuite\BuildModelResult.log                  10916      0
        K:\AosService\PackagesLocalDirectory\CustomModule\BuildModelResult.log                          1      2
        
    .EXAMPLE
        PS C:\> Get-D365VisualStudioCompilerResult -ErrorsOnly
        
        This will return the compiler output for all modules where there was errors in.
        
        A result set example:
        
        File                                                                                     Warnings Errors
        ----                                                                                     -------- ------
        K:\AosService\PackagesLocalDirectory\CustomModule\BuildModelResult.log                          1      2
        
    .EXAMPLE
        PS C:\> Get-D365VisualStudioCompilerResult -ErrorsOnly -OutputAsObjects
        
        This will return the compiler output for all modules where there was errors in.
        The output will be PSObjects, which can be assigned to a variable and used for futher analysis.
        
        A result set example:
        
        File                                                                                     Warnings Errors
        ----                                                                                     -------- ------
        K:\AosService\PackagesLocalDirectory\CustomModule\BuildModelResult.log                          1      2
        
    .EXAMPLE
        PS C:\> Get-D365VisualStudioCompilerResult -OutputTotals
        
        This will return the compiler output for all modules and write a total overview to the console.
        
        A result set example:
        
        File                                                                                     Warnings Errors
        ----                                                                                     -------- ------
        K:\AosService\PackagesLocalDirectory\ApplicationCommon\BuildModelResult.log                    55      0
        K:\AosService\PackagesLocalDirectory\ApplicationFoundation\BuildModelResult.log               692      0
        K:\AosService\PackagesLocalDirectory\ApplicationPlatform\BuildModelResult.log                 155      0
        K:\AosService\PackagesLocalDirectory\ApplicationSuite\BuildModelResult.log                  10916      0
        K:\AosService\PackagesLocalDirectory\CustomModule\BuildModelResult.log                          1      2
        
        
        Total Errors: 2
        Total Warnings: 11819
        
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
function Get-D365VisualStudioCompilerResult {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    [OutputType('[PsCustomObject]')]
    param (
        [Alias("ModuleName")]
        [string] $Module = "*",

        [switch] $ErrorsOnly,

        [switch] $OutputTotals,

        [switch] $OutputAsObjects,

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    Invoke-TimeSignal -Start

    if (-not (Test-PathExists -Path $PackageDirectory -Type Container)) { return }

    $buildOutputFiles = Get-ChildItem -Path "$PackageDirectory\$Module\BuildModelResult.log" -ErrorAction SilentlyContinue -Force

    $outputCollection = New-Object System.Collections.Generic.List[System.Object]

    foreach ($result in $buildOutputFiles) {
        
        $res = Get-CompilerResult -Path $result.FullName

        if ($null -ne $res) {
            $outputCollection.Add($res)
        }
    }

    $totalErrors = 0
    $totalWarnings = 0

    $resCol = @($outputCollection.ToArray())
    
    $totalWarnings = ($resCol | Measure-Object -Property Warnings -Sum).Sum
    $totalErrors = ($resCol | Measure-Object -Property Errors -Sum).Sum

    if ($ErrorsOnly) {
        $resCol = @($resCol | Where-Object Errors -gt 0)
    }

    if ($OutputAsObjects) {
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