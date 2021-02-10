
<#
    .SYNOPSIS
        Generate Report for all related objects
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all related objects and generate a metadata report for each
        
    .PARAMETER OutputPath
        Path to where you want the report file to be saved
        
        The default value is: "c:\temp\d365fo.tools\"
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Invoke-D365GenerateReports
        
        This will generate a report for each related object.
        It will contain all the metadata and save it into a xlsx (Excel) file.
        It will saved the file to "c:\temp\d365fo.tools\"
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
function Invoke-D365GenerateReports {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param (
        [string] $OutputPath = $Script:DefaultTempPath,

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    process {
        Invoke-TimeSignal -Start

        $reports = @()

        $reports += Invoke-D365GenerateReportAggregateDataEntity @PSBoundParameters
        $reports += Invoke-D365GenerateReportAggregateMeasure @PSBoundParameters
        $reports += Invoke-D365GenerateReportConfigKey @PSBoundParameters
        $reports += Invoke-D365GenerateReportConfigKeyGroup @PSBoundParameters
        $reports += Invoke-D365GenerateReportDataEntity @PSBoundParameters
        $reports += Invoke-D365GenerateReportDataEntityField @PSBoundParameters
        $reports += Invoke-D365GenerateReportKpi @PSBoundParameters
        $reports += Invoke-D365GenerateReportLicenseCode @PSBoundParameters
        $reports += Invoke-D365GenerateReportMenuItem @PSBoundParameters
        $reports += Invoke-D365GenerateReportSsrs @PSBoundParameters
        $reports += Invoke-D365GenerateReportTable @PSBoundParameters
        $reports += Invoke-D365GenerateReportWorkflowType @PSBoundParameters

        Invoke-TimeSignal -End

        $reports


    }
}