
<#
    .SYNOPSIS
        Deploy Report
        
    .DESCRIPTION
        Deploy SSRS Report to SQL Server Reporting Services
        
    .PARAMETER Module
        Name of the module that you want to works against
        
        Accepts an array of strings
        
        Default value is "*" and will work against all modules loaded on the machine
        
    .PARAMETER ReportName
        Name of the report that you want to deploy
        
        Default value is "*" and will deploy all reports from the module(s) that you speficied
        
    .PARAMETER LogFile
        Path to the file that should contain the logging information
        
        Default value is "c:\temp\d365fo.tools\AxReportDeployment.log"
        
    .PARAMETER PackageDirectory
        Path to the PackagesLocalDirectory
        
        Default path is the same as the AOS Service PackagesLocalDirectory
        
    .PARAMETER ToolsBasePath
        Base path to the folder containing the needed PowerShell manifests that the cmdlet utilizes
        
        Default path is the same as the AOS Service PackagesLocalDirectory
        
    .PARAMETER ReportServerIp
        IP Address of the server that has SQL Reporting Services installed
        
        Default value is "127.0.01"
        
    .EXAMPLE
        PS C:\> Publish-D365SsrsReport -Module ApplicationSuite -ReportName TaxVatRegister.Report
        
        This will deploy the report which is named "TaxVatRegister.Report".
        The cmdlet will look for the report inside the ApplicationSuite module.
        The cmdlet will be using the default 127.0.0.1 while deploying the report.
        
    .EXAMPLE
        PS C:\> Publish-D365SsrsReport -Module ApplicationSuite -ReportName *
        
        This will deploy the all reports from the ApplicationSuite module.
        The cmdlet will be using the default 127.0.0.1 while deploying the report.
        
    .NOTES
        Tags: SSRS, Report, Reports, Deploy, Publish
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Publish-D365SsrsReport {
    [CmdletBinding()]
    [OutputType('[PsCustomObject]')]
    param (
        [Parameter(Mandatory = $false)]
        [string[]] $Module = "*",

        [Parameter(Mandatory = $false)]
        [string[]] $ReportName = "*",

        [Parameter(Mandatory = $false)]
        [string] $LogFile = (Join-Path $Script:DefaultTempPath "AxReportDeployment.log"),

        [Parameter(Mandatory = $false)]
        [string] $PackageDirectory = $Script:PackageDirectory,

        [Parameter(Mandatory = $false)]
        [string] $ToolsBasePath = $Script:PackageDirectory,

        [Parameter(Mandatory = $false)]
        [string[]]$ReportServerIp = "127.0.0.1"
    )

    Invoke-TimeSignal -Start

    $LogDirectory = Split-Path $LogFile -Parent
    $toolsPath = Join-Path $ToolsBasePath "Plugins\AxReportVmRoleStartupTask"
    
    if (-not (Test-PathExists -Path $toolsPath, $PackageDirectory -Type Container)) { return }
    if (-not (Test-PathExists -Path $LogDirectory -Type Container -Create)) { return }

    $aosCommonManifest = Join-Path $toolsPath "AosCommon.psm1"
    $reportingManifest = Join-Path $toolsPath "Reporting.psm1"

    if (-not (Test-PathExists -Path $aosCommonManifest, $reportingManifest -Type Leaf)) { return }

    Write-PSFMessage -Level Verbose -Message "Importing the Microsoft AosCommon PowerShell manifest file." -Target $aosCommonManifest
    Import-Module "$aosCommonManifest" -Force -DisableNameChecking
    
    Write-PSFMessage -Level Verbose -Message "Importing the Microsoft Reporting PowerShell manifest file." -Target $reportingManifest
    Import-Module "$reportingManifest" -Force -DisableNameChecking

    # create JSON config string for Deploy-AxReports
    $settings = New-Object -TypeName PSCustomObject -Property @{
        "BiReporting.ReportingServers"                       = $($ReportServerIp -join ",")
        "Microsoft.Dynamics.AX.AosConfig.AzureConfig.bindir" = $PackageDirectory
        "Module"                                             = $Module
        "ReportName"                                         = $ReportName
    }

    Write-PSFMessage -Level Verbose -Message "Done building the settings object that will be parsed." -Target $settings
    
    $jsonConfig = ConvertTo-Json $settings

    Write-PSFMessage -Level Verbose -Message "Settings object converted to json." -Target $jsonConfig

    $jsonConfig = [System.Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($jsonConfig))

    try {
    
        Write-PSFMessage -Level Verbose -Message "Invoking the 'Deploy-AxReport' cmdlet from Microsoft."

        Deploy-AxReport -Config $jsonConfig -Log $LogFile
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while deploying the SSRS Report(s)" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    Invoke-TimeSignal -End
    
    [PSCustomObject]@{
		LogFile = $LogFile
	}
}