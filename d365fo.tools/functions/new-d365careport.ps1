
<#
    .SYNOPSIS
        Generate the Customization's Analysis Report (CAR)
        
    .DESCRIPTION
        A cmdlet that wraps some of the cumbersome work into a streamlined process
        
    .PARAMETER Path
        Full path to CAR file (xlsx-file)
        
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
        
    .EXAMPLE
        PS C:\> New-D365CAReport -Path "c:\temp\CAReport.xlsx" -module "ApplicationSuite" -model "MyOverLayerModel"
        
        This will generate a CAR report against MyOverLayerModel in the ApplicationSuite Module, and save the report to "c:\temp\CAReport.xlsx"
        
    .NOTES
        Author: Tommy Skaue (@Skaue)
        
#>
function New-D365CAReport {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1 )]
        [Alias('File')]
        [string] $Path = (Join-Path $Script:DefaultTempPath "CAReport.xlsx"),

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $true, Position = 4 )]
        [Alias('Package')]
        [string] $Module,

        [Parameter(Mandatory = $true, Position = 5 )]
        [string] $Model,

        [Parameter(Mandatory = $false, Position = 6 )]
        [string] $XmlLog = (Join-Path $Script:DefaultTempPath "BPCheckLogcd.xml")


    )
    
    if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) {return}

    $executable = Join-Path $BinDir "xppbp.exe"
    if (-not (Test-PathExists -Path $executable -Type Leaf)) {return}

    $param = @(
        "-metadata=`"$MetaDataDir`"",
        "-all",
        "-module=`"$Module`"",
        "-model=`"$Model`"",
        "-xmlLog=`"$XmlLog`"",
        "-car=`"$Path`""
        )

    Write-PSFMessage -Level Verbose -Message "Starting the $executable with the parameter options." -Target $param
    Start-Process -FilePath $executable -ArgumentList  ($param -join " ") -NoNewWindow -Wait
}