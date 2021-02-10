
<#
    .SYNOPSIS
        Generate Report for Aggregate Measure
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all Aggregate Measures and generate a metadata report
        
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
        PS C:\> Invoke-D365GenerateReportAggregateMeasure
        
        This will generate a report.
        It will contain all the metadata and save it into a xlsx (Excel) file.
        It will saved the file to "c:\temp\d365fo.tools\"
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
function Invoke-D365GenerateReportAggregateMeasure {
    [CmdletBinding()]
    param (
        [string] $OutputPath = $Script:DefaultTempPath,

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        $outputFile = Join-Path -Path $OutputPath -ChildPath "AggregateMeasures.xlsx"

        Write-PSFMessage -Level Verbose -Message "Getting all Aggregate Measures from the internal functions."
        $aggregateMeasures = Get-AxAggregateMeasures -BinDir $BinDir -PackageDirectory $PackageDirectory

        $productVersionDetails = Get-D365ProductInformation
        
        if (-not $productVersionDetails.ApplicationBuildVersion) {
            $version = $productVersionDetails.ApplicationVersion
        }
        else {
            $version = $productVersionDetails.ApplicationBuildVersion
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        
        $reportName = "AggregateMeasures"
        $sheetName = "$reportName`_$version"
        $sheetName = $sheetName.subString(0, [System.Math]::Min(31, $sheetName.Length))

        $aggregateMeasures | Sort-Object Name | Export-Excel -Path $outputFile -WorksheetName $sheetName -ClearSheet -AutoSize -TableName $reportName
        
        [PSCustomObject]@{
            Report = $reportName
            File     = $outputFile
            Filename = (Split-Path $outputFile -Leaf)
        }
    }
}