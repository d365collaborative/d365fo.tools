
<#
    .SYNOPSIS
        Analyze the compiler output log
        
    .DESCRIPTION
        Analyze the compiler output log and generate an excel file contain worksheets per type: Errors, Warnings, Tasks
        
        It could be a Visual Studio compiler log or it could be a Invoke-D365ModuleCompile log you want analyzed
        
    .PARAMETER Path
        Path to the compiler log file that you want to work against
        
        A BuildModelResult.log or a Dynamics.AX.*.xppc.log file will both work
        
    .PARAMETER OutputPath
        Path where you want the excel file (xlsx-file) saved to
        
    .PARAMETER SkipWarnings
        Instructs the cmdlet to skip warnings while analyzing the compiler output log file
        
    .PARAMETER SkipTasks
        Instructs the cmdlet to skip tasks while analyzing the compiler output log file
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Default path is the same as the AOS service "PackagesLocalDirectory" directory
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Invoke-D365CompilerResultAnalyzer -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log"
        
        This will analyse all compiler output log files generated from Visual Studio.
        It will use the default path for the OutputPath parameter.
        
        It will build error and error summary worksheets.
        It will build warning and warning summary worksheets.
        It will build task and task summary worksheets.
        
        A result set example:
        
        File                                                            Filename
        ----                                                            --------
        c:\temp\d365fo.tools\Custom-CompilerResults.xlsx                Custom-CompilerResults.xlsx
        
    .EXAMPLE
        PS C:\> Invoke-D365CompilerResultAnalyzer -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log" -SkipWarnings
        
        This will analyse all compiler output log files generated from Visual Studio.
        It will use the default path for the OutputPath parameter.
        
        It will build error and error summary worksheets.
        It will build task and task summary worksheets.
        
        A result set example:
        
        File                                                            Filename
        ----                                                            --------
        c:\temp\d365fo.tools\Custom-CompilerResults.xlsx                Custom-CompilerResults.xlsx
        
    .EXAMPLE
        PS C:\> Invoke-D365CompilerResultAnalyzer -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log" -SkipTasks
        
        This will analyse all compiler output log files generated from Visual Studio.
        It will use the default path for the OutputPath parameter.
        
        It will build error and error summary worksheets.
        It will build warning and warning summary worksheets.
        
        A result set example:
        
        File                                                            Filename
        ----                                                            --------
        c:\temp\d365fo.tools\Custom-CompilerResults.xlsx                Custom-CompilerResults.xlsx
        
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
function Invoke-D365CompilerResultAnalyzer {
    [CmdletBinding()]
    [OutputType('')]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('LogFile')]
        [string] $Path,

        [string] $OutputPath = $Script:DefaultTempPath,

        [switch] $SkipWarnings,

        [switch] $SkipTasks,

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        Invoke-TimeSignal -Start

        if (-not (Test-PathExists -Path $PackageDirectory -Type Container)) { return }
    }

    process {

        $moduleName = ""

        if($Path -like "*Dynamics.AX.*.xppc.log"){
            $splittedString = $Path -split ".*Dynamics.AX.(.*).xppc.log"
            $moduleName = $splittedString[1]
        }elseif ($Path -like "*BuildModelResult.log"){
            $splittedString = $Path -split ".*\\(.*)\\BuildModelResult.log"
            $moduleName = $splittedString[1]
        }else{
            $moduleName = (New-Guid).Guid
        }

        $outputFilePath = Join-Path -Path $OutputPath -ChildPath "$moduleName-CompilerResults.xlsx"

        Invoke-CompilerResultAnalyzer -Path $Path -Identifier $moduleName -OutputPath $outputFilePath -SkipWarnings:$SkipWarnings -SkipTasks:$SkipTasks -PackageDirectory $PackageDirectory
    }
    
    end {
        Invoke-TimeSignal -End
    }
}