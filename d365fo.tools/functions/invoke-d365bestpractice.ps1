
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
        
    .PARAMETER LogDir
        Path where you want to store the log outputs generated from the best practice analyser
        
    .PARAMETER PackagesRoot
        Instructs the cmdlet to use binary metadata
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER RunFixers
        Instructs the cmdlet to invoke the fixers for the identified warnings
        
    .EXAMPLE
        PS C:\> Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel"
        
        This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.
        The default output will be silenced.
        The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
        The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".

    .EXAMPLE
        PS C:\> Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel" -ShowOriginalProgress
        
        This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.        
        The output from the best practice check process will be written to the console / host.
        The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
        The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".

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
        [Parameter(Mandatory = $false, Position = 1 )]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $true, Position = 3 )]
        [Alias('Package')]
        [string] $Module,

        [Parameter(Mandatory = $true, Position = 4 )]
        [string] $Model,

        [Parameter(Mandatory = $false, Position = 5 )]
        [string] $LogDir = (Join-Path $Script:DefaultTempPath $Module),

		[Parameter(Mandatory = $false, Position = 6 )]
        [switch] $PackagesRoot,

        [Parameter(Mandatory = $false, Position = 7 )]
        [switch] $ShowOriginalProgress,

        [Parameter(Mandatory = $false, Position = 8 )]
        [switch] $RunFixers
    )

	Invoke-TimeSignal -Start

    $tool = "xppbp.exe"
    $executable = Join-Path $BinDir $tool

    if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) {return}
    if (-not (Test-PathExists -Path $LogDir -Type Container -Create)) {return}
    if (-not (Test-PathExists -Path $executable -Type Leaf)) {return}

	$logFile = Join-Path $LogDir "Dynamics.AX.$Model.xppbp.log"
    $logXmlFile = Join-Path $LogDir "Dynamics.AX.$Model.xppbp.xml"

    $params = @(
        "-metadata=`"$MetaDataDir`"",
        "-all",
        "-module=`"$Module`"",
        "-model=`"$Model`"",
        "-xmlLog=`"$logXmlFile`"",
        "-log=`"$logFile`""
        )
	
	if ($PackagesRoot -eq $true)
	{
		$params +="-packagesroot=`"$MetaDataDir`""
	}

	if ($RunFixers -eq $true)
	{
		$params +="-runfixers"
	}

    Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress

	Invoke-TimeSignal -End

	[PSCustomObject]@{
		LogFile = $logFile
		XmlLogFile = $logXmlFile
	}
}