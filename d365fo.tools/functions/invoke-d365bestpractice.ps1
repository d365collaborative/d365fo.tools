
<#
    .SYNOPSIS
        Run the Best Practice
        
    .DESCRIPTION
        Run the Best Practice checks against modules and models
        
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
        
    .PARAMETER PackagesRoot
        Instructs the cmdlet to use binary metadata
        
    .PARAMETER LogPath
        Path where you want to store the log outputs generated from the best practice analyser
        
        Also used as the path where the log file(s) will be saved
        
        When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER RunFixers
        Instructs the cmdlet to invoke the fixers for the identified warnings
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .EXAMPLE
        PS C:\> Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel"
        
        This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.
        The default output will be silenced.
        The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
        The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".
        
    .EXAMPLE
        PS C:\> Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel" -PackagesRoot
        
        This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.
        We use the binary metadata to look for the module and model.
        The default output will be silenced.
        The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
        The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".
        
    .EXAMPLE
        PS C:\> Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel" -ShowOriginalProgress
        
        This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.
        The output from the best practice check process will be written to the console / host.
        The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
        The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".
        
    .EXAMPLE
        PS C:\> Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel" -RunFixers
        
        This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.
        The default output will be silenced.
        The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
        The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".
        Instructs the xppbp tool to run the fixers for all identified warnings.
        
    .NOTES
        Tags: Best Practice, BP, BPs, Module, Model, Quality
        
        Author: Gert Van Der Heyden (@gertvdheyden)
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365BestPractice {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    [OutputType('[PsCustomObject]')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("ModuleName")]
        [string] $Module,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ModelName')]
        [string] $Model,

        [string] $BinDir = "$Script:PackageDirectory\bin",

        [string] $MetaDataDir = "$Script:MetaDataDir",

        [switch] $PackagesRoot,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\BestPractice"),

        [switch] $ShowOriginalProgress,

        [switch] $RunFixers,

        [switch] $OutputCommandOnly
    )

    begin {
        Invoke-TimeSignal -Start

        $tool = "xppbp.exe"
        $executable = Join-Path -Path $BinDir -ChildPath $tool

        if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) { return }
        if (-not (Test-PathExists -Path $executable -Type Leaf)) { return }
    
    }
    
    process {
        if (Test-PSFFunctionInterrupt) { return }

        $logDirModule = (Join-Path -Path $LogPath -ChildPath $Module)

        if (-not (Test-PathExists -Path $logDirModule -Type Container -Create)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        $logFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$Model.xppbp.log"
        $logXmlFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$Model.xppbp.xml"

        $params = @(
            "-metadata=`"$MetaDataDir`"",
            "-all",
            "-module=`"$Module`"",
            "-model=`"$Model`"",
            "-xmlLog=`"$logXmlFile`"",
            "-log=`"$logFile`""
        )
	
        if ($PackagesRoot -eq $true) {
            $params += "-packagesroot=`"$MetaDataDir`""
        }

        if ($RunFixers -eq $true) {
            $params += "-runfixers"
        }

        Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $logDirModule

        if ($OutputCommandOnly) { return }
        
        [PSCustomObject]@{
            LogFile    = $logFile
            XmlLogFile = $logXmlFile
        }
    }

    end {
        Invoke-TimeSignal -End
    }
}