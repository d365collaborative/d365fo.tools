
<#
    .SYNOPSIS
        Analyze the Visual Studio compiler output log
        
    .DESCRIPTION
        Analyze the Visual Studio compiler output log and generate an excel file contain worksheets per type: Errors, Warnings, Tasks
        
    .PARAMETER Module
        Name of the module that you want to work against
        
        Default value is "*" which will search for all modules
        
    .PARAMETER OutputPath
        Path where you want the excel file (xlsx-file) saved to
        
        Default value is: "c:\temp\d365fo.tools\"
        
    .PARAMETER SkipWarnings
        Instructs the cmdlet to skip warnings while analyzing the compiler output log file
        
    .PARAMETER SkipTasks
        Instructs the cmdlet to skip tasks while analyzing the compiler output log file
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Default path is the same as the AOS service "PackagesLocalDirectory" directory
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Invoke-D365VisualStudioCompilerResultAnalyzer
        
        This will analyse all compiler output log files generated from Visual Studio.
        
        A result set example:
        
        File                                                            Filename
        ----                                                            --------
        c:\temp\d365fo.tools\ApplicationCommon-CompilerResults.xlsx     ApplicationCommon-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationFoundation-CompilerResults.xlsx ApplicationFoundation-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationPlatform-CompilerResults.xlsx   ApplicationPlatform-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationSuite-CompilerResults.xlsx      ApplicationSuite-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationWorkspaces-CompilerResults.xlsx ApplicationWorkspaces-CompilerResults.xlsx
        
    .EXAMPLE
        PS C:\> Invoke-D365VisualStudioCompilerResultAnalyzer -SkipWarnings
        
        This will analyse all compiler output log files generated from Visual Studio.
        It will exclude all warnings from the output.
        
        A result set example:
        
        File                                                            Filename
        ----                                                            --------
        c:\temp\d365fo.tools\ApplicationCommon-CompilerResults.xlsx     ApplicationCommon-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationFoundation-CompilerResults.xlsx ApplicationFoundation-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationPlatform-CompilerResults.xlsx   ApplicationPlatform-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationSuite-CompilerResults.xlsx      ApplicationSuite-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationWorkspaces-CompilerResults.xlsx ApplicationWorkspaces-CompilerResults.xlsx
        
    .EXAMPLE
        PS C:\> Invoke-D365VisualStudioCompilerResultAnalyzer -SkipTasks
        
        This will analyse all compiler output log files generated from Visual Studio.
        It will exclude all tasks from the output.
        
        A result set example:
        
        File                                                            Filename
        ----                                                            --------
        c:\temp\d365fo.tools\ApplicationCommon-CompilerResults.xlsx     ApplicationCommon-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationFoundation-CompilerResults.xlsx ApplicationFoundation-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationPlatform-CompilerResults.xlsx   ApplicationPlatform-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationSuite-CompilerResults.xlsx      ApplicationSuite-CompilerResults.xlsx
        c:\temp\d365fo.tools\ApplicationWorkspaces-CompilerResults.xlsx ApplicationWorkspaces-CompilerResults.xlsx
        
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
function Invoke-D365VisualStudioCompilerResultAnalyzer {
    [CmdletBinding()]
    [OutputType('')]
    param (
        [Alias("ModuleName")]
        [string] $Module = "*",

        [string] $OutputPath = $Script:DefaultTempPath,

        [switch] $SkipWarnings,

        [switch] $SkipTasks,

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    Invoke-TimeSignal -Start

    if (-not (Test-PathExists -Path $PackageDirectory -Type Container)) { return }
    
    $buildOutputFiles = Get-ChildItem -Path "$PackageDirectory\$Module\BuildModelResult.log" -ErrorAction SilentlyContinue -Force

    foreach ($result in $buildOutputFiles) {
        
        $moduleName = Split-Path -Path $result.DirectoryName -Leaf
        $outputFilePath = Join-Path -Path $OutputPath -ChildPath "$moduleName-CompilerResults.xlsx"

        Invoke-CompilerResultAnalyzer -Path $result.FullName -Identifier $moduleName -OutputPath $outputFilePath -SkipWarnings:$SkipWarnings -SkipTasks:$SkipTasks -PackageDirectory $PackageDirectory
    }

    Invoke-TimeSignal -End
}