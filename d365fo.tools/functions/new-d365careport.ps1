
<#
    .SYNOPSIS
        Generate the Customization's Analysis Report (CAR)
        
    .DESCRIPTION
        A cmdlet that wraps some of the cumbersome work into a streamlined process
        
    .PARAMETER OutputPath
        Path where you want the CAR file (xlsx-file) saved to
        
        Default value is: "c:\temp\d365fo.tools\CAReport.xlsx"
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER Module
        Name of the Module to analyse
        
    .PARAMETER Model
        Name of the Model to analyse
        
    .PARAMETER XmlLog
        Path where you want to store the Xml log output generated from the best practice analyser
        
    .PARAMETER PackagesRoot
        Instructs the cmdlet to use binary metadata
        
    .PARAMETER LogPath
        The path where the log file(s) will be saved
        
        When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .PARAMETER SuffixWithModule
        Instruct the cmdlet to append the module name as a suffix to the desired output file name
        
    .EXAMPLE
        PS C:\> New-D365CAReport -module "ApplicationSuite" -model "MyOverLayerModel"
        
        This will generate a CAR report against MyOverLayerModel in the ApplicationSuite Module.
        It will use the default value for the OutputPath parameter, which is "c:\temp\d365fo.tools\CAReport.xlsx".
        
    .EXAMPLE
        PS C:\> New-D365CAReport -OutputPath "c:\temp\CAReport.xlsx" -module "ApplicationSuite" -model "MyOverLayerModel"
        
        This will generate a CAR report against MyOverLayerModel in the ApplicationSuite Module.
        It will use the "c:\temp\CAReport.xlsx" value for the OutputPath parameter.
        
    .EXAMPLE
        PS C:\> New-D365CAReport -module "ApplicationSuite" -model "MyOverLayerModel" -SuffixWithModule
        
        This will generate a CAR report against MyOverLayerModel in the ApplicationSuite Module.
        It will use the default value for the OutputPath parameter, which is "c:\temp\d365fo.tools\CAReport.xlsx".
        It will append the module name to the desired output file, which will then be "c:\temp\d365fo.tools\CAReport-ApplicationSuite.xlsx".
        
    .EXAMPLE
        PS C:\> New-D365CAReport -OutputPath "c:\temp\CAReport.xlsx" -module "ApplicationSuite" -model "MyOverLayerModel" -PackagesRoot
        
        This will generate a CAR report against MyOverLayerModel in the ApplicationSuite Module.
        It will use the binary metadata to look for the module and model.
        It will use the "c:\temp\CAReport.xlsx" value for the OutputPath parameter.
        
    .NOTES
        Author: Tommy Skaue (@Skaue)
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function New-D365CAReport {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param (
        [Alias('File')]
        [Alias('Path')]
        [string] $OutputPath = (Join-Path $Script:DefaultTempPath "CAReport.xlsx"),

        [Parameter(Mandatory = $true)]
        [Alias('Package')]
        [Alias("ModuleName")]
        [string] $Module,
        
        [Parameter(Mandatory = $true)]
        [string] $Model,

        [switch] $SuffixWithModule,

        [string] $BinDir = "$Script:PackageDirectory\bin",

        [string] $MetaDataDir = "$Script:MetaDataDir",

        [string] $XmlLog = (Join-Path $Script:DefaultTempPath "BPCheckLogcd.xml"),

        [switch] $PackagesRoot,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\CAReport"),

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )
    
    if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) { return }

    $executable = Join-Path $BinDir "xppbp.exe"
    if (-not (Test-PathExists -Path $executable -Type Leaf)) { return }

    if ($SuffixWithModule) {
        $OutputPath = $OutputPath.Replace(".xlsx", "-$Module.xlsx")
    }

    $params = @(
        "-metadata=`"$MetaDataDir`"",
        "-all",
        "-module=`"$Module`"",
        "-model=`"$Model`"",
        "-xmlLog=`"$XmlLog`"",
        "-car=`"$OutputPath`""
    )

    if ($PackagesRoot -eq $true) {
        $params += "-packagesroot=`"$MetaDataDir`""
    }

    Write-PSFMessage -Level Verbose -Message "Starting the $executable with the parameter options." -Target $param

    Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath

    if (Test-PSFFunctionInterrupt) { return }

    [PSCustomObject]@{
        File     = $OutputPath
        Filename = (Split-Path $OutputPath -Leaf)
    }
}