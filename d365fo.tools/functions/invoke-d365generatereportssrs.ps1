
<#
    .SYNOPSIS
        Generate Report for SSRS Report
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all SSRS Reports and generate a metadata report
        
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
        PS C:\> Invoke-D365GenerateReportSsrs
        
        This will generate a report.
        It will contain all the metadata and save it into a xlsx (Excel) file.
        It will saved the file to "c:\temp\d365fo.tools\"
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
function Invoke-D365GenerateReportSsrs {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param (
        [string] $OutputPath = $Script:DefaultTempPath,

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        $outputFile = Join-Path -Path $OutputPath -ChildPath "SSRSReports.xlsx"

        Import-GenerateReportAssemblies

        $providerConfig = New-Object Microsoft.Dynamics.AX.Metadata.Storage.DiskProvider.DiskProviderConfiguration
        $providerConfig.XppMetadataPath = $PackageDirectory
        $providerConfig.MetadataPath = $PackageDirectory

        $providerFactory = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
        $metadataProvider = $providerFactory.CreateDiskProvider($providerConfig)

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
        
        Write-PSFMessage -Level Verbose -Message "Getting all SSRS Reports via the metadata provider."
        $reportsModelInfos = $metadataProvider.Reports.GetPrimaryKeysWithModelInfo()

        #array of the names of all the reports that use Print Management (used PrintMgmtReportFormat table from Application Explorer)
        $printMgmtReports = @("SalesInvoice", "SalesConfirm", "SalesPackingSlip", "WMSPickingList_OrderPick", "FreeTestInvoice", "SalesQuotationConfirmation",
            "SalesQuotation", "VendInvoiceDocument", "PurchPackingSlip", "PurchReceiptsList", "PurchPurchaseOrder", "ProjInvoice",
            "PurchRFQFormLetter_Send", "CustInterestNote", "CustCOllectionJour", "CustAccountStatementExt", "AgreementConfirmation", "PSAQuotations",
            "PSAProjInvoice", "PSAContractLineInvoice", "PSAManageInvoice", "PSAManageInvoiceBR", "PSACustRetentionReleaseInvoice")

        $reports = New-Object System.Collections.Generic.List[object]

        foreach ($tuple in $reportsModelInfos) {
            $elementName = $tuple.Item1

            Write-PSFMessage -Level Verbose -Message "Working on: $elementName (SsrsReport)" -Target $elementName

            $element = $metadataProvider.Reports.Read($elementName)

            $printMgmt = $($printMgmtReports -contains $element.Name)

            foreach ($i in $element.DataSets) {
                #filter out system fields
                $fields = @()
                foreach ($j in $i.Fields) {
                    if ($j -notlike "AX_*") {
                        $fields += $j
                    }
                }
                
                $filters = @()
                #filter out system parameters
                foreach ($k in $i.Parameters) {
                    if ($k -notlike "AX_*") {
                        $filters += $k
                    }
                }
                  
                $outItems = [PsCustomObject][ordered]@{ # create a hash table of the name/value pair
                    Name      = $element.Name
                    DataSet   = $i.Name
                    Filters   = [string]::Join(", ", $filters)
                    Fields    = [string]::Join(", ", $fields)
                    PrintMgmt = $printMgmt
                }

                $reports.Add($outItems)
            }
        }
        
        $reportName = "SSRSReports"
        $sheetName = "$reportName`_$version"
        $sheetName = $sheetName.subString(0, [System.Math]::Min(31, $sheetName.Length))

        $reports | Sort-Object Name | Export-Excel -Path $outputFile -WorksheetName $sheetName -ClearSheet -AutoSize -TableName $reportName

        [PSCustomObject]@{
            Report   = $reportName
            File     = $outputFile
            Filename = (Split-Path $outputFile -Leaf)
        }
    }
}