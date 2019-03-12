
<#
    .SYNOPSIS
        Runs the Best Practices checks
        
    .DESCRIPTION
        A cmdlet that wraps some of the cumbersome work into a streamlined process
        
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
        Indicates to use binary metadata 
        
    .EXAMPLE
        PS C:\> Invoke-D365BestPractices -module "ApplicationSuite" -model "MyOverLayerModel"
        
        This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module
        
    .NOTES
        Author: Gert Van Der Heyden (@gertvdheyden)
        
#>

function Invoke-D365BestPractices {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
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
        [string] $XmlLog = (Join-Path $Script:DefaultTempPath "BPCheckLogcd.xml"),

		[Parameter(Mandatory = $false, Position = 6 )]
        [switch] $PackagesRoot 


    )
    
    if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) {return}

    $executable = Join-Path $BinDir "xppbp.exe"
    if (-not (Test-PathExists -Path $executable -Type Leaf)) {return}

    $param = @(
        "-metadata=`"$MetaDataDir`"",
        "-all",
        "-module=`"$Module`"",
        "-model=`"$Model`"",
        "-xmlLog=`"$XmlLog`""	
        )
	
	if ($PackagesRoot -eq $true)
	{
		$param +="-packagesroot=`"$MetaDataDir`""	
	}       

    Write-PSFMessage -Level Verbose -Message "Starting the $executable with the parameter options." -Target $param
    Start-Process -FilePath $executable -ArgumentList  ($param -join " ") -NoNewWindow -Wait
}