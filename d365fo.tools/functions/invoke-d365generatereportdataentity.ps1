
<#
    .SYNOPSIS
        Generate Report for Data Entity
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all Data Entities and generate a metadata report
        
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
        PS C:\> Invoke-D365GenerateReportDataEntity
        
        This will generate a report.
        It will contain all the metadata and save it into a xlsx (Excel) file.
        It will saved the file to "c:\temp\d365fo.tools\"
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
function Invoke-D365GenerateReportDataEntity {
    [CmdletBinding()]
    param (
        [string] $OutputPath = $Script:DefaultTempPath,

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        $outputFile = Join-Path -Path $OutputPath -ChildPath "DataEntities.xlsx"

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
        
        Write-PSFMessage -Level Verbose -Message "Getting all Data Entities via the metadata provider."
        $dataEntityModelInfos = $metadataProvider.DataEntityViews.GetPrimaryKeysWithModelInfo()

        $dataEntities = New-Object System.Collections.Generic.List[object]
        
        foreach ($tuple in $dataEntityModelInfos) {
            $elementName = $tuple.Item1

            Write-PSFMessage -Level Verbose -Message "Working on: $elementName (DataEntity)" -Target $elementName
            
            $element = $metadataProvider.DataEntityViews.Read($elementName)

            #filter out system fields
            $fields = @()
            foreach ($j in $element.Fields) {
                if ($j -notlike "AX_*") {
                    $fields += $j
                }
            }

            $outItems = [PsCustomObject][ordered] @{ # create a hash table of the name/value pair
                Name                  = $element.Name
                DataSource            = [string]::Join(", ", $element.ViewMetadata.DataSources)
                Public                = $element.IsPublic
                ODataAccessible       = $element.IsPublic
                PublicCollectionName  = $element.PublicCollectionName
                StagingTable          = $element.DataManagementStagingTable
                EntityCategory        = $element.EntityCategory
                TableGroup            = $element.TableGroup
                Fields                = [string]::Join(", ", $fields)
                DataManagementEnabled = $element.DataManagementEnabled
            }

            $dataEntities.add($outItems)
        }

        $reportName = "DataEntities"
        $sheetName = "$reportName`_$version"
        $sheetName = $sheetName.subString(0, [System.Math]::Min(31, $sheetName.Length))

        $dataEntities | Sort-Object Name | Export-Excel -Path $outputFile -WorksheetName $sheetName -ClearSheet -AutoSize -TableName $reportName

        [PSCustomObject]@{
            Report = $reportName
            File     = $outputFile
            Filename = (Split-Path $outputFile -Leaf)
        }
    }
}