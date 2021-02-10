
<#
    .SYNOPSIS
        Get Data Entity
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all Data Entities and their fields
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-AxDataEntities
        
        This will get all objects.
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
Function Get-AxDataEntities {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param(

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    BEGIN {
        Import-GenerateReportAssemblies

        $providerConfig = New-Object Microsoft.Dynamics.AX.Metadata.Storage.DiskProvider.DiskProviderConfiguration
        $providerConfig.XppMetadataPath = $PackageDirectory
        $providerConfig.MetadataPath = $PackageDirectory

        $providerFactory = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
        $metadataProvider = $providerFactory.CreateDiskProvider($providerConfig)
    }

    PROCESS {

        $dataEntityModelInfos = $metadataProvider.DataEntityViews.GetPrimaryKeysWithModelInfo()

        foreach ($tuple in $dataEntityModelInfos) {
            $elementName = $tuple.Item1

            $element = $metadataProvider.DataEntityViews.Read($elementName)

            #
            # Build list of DataSources
            #
            $datasourceList = @()
            foreach ($datasource in $element.ViewMetadata.DataSources) {
                $datasourceList += New-Object PSObject -Property @{ # create a hash table of the name/value pair
                    DataSourceName  = $datasource.Name
                    DataSourceTable = $datasource.Table
                }
                $datasourceList += QueryDataSourceRecursion $datasource.DataSources
            }

            #
            # Convert DataSource list to hash
            #
            $dataSourceHash = @{}
            $datasourceList | ForEach-Object {
                $dataSourceHash[$_.DataSourceName] = $_
            }

            foreach ($j in $element.Fields) {

                #filter out system fields
                if ($j -notlike "AX_*") {
                    $typeName = $j.GetType().Name
                    $field_binding = ""

                    if ($typename -eq "AxDataEntityViewMappedField") {

                        $tableName = ""
                        if ($dataSourceHash.ContainsKey($j.DataSource)) {
                            $tableName = $dataSourceHash[$j.DataSource].DataSourceTable
                        }
                        $field_binding = $j.DataSource + "(" + $tableName + ")." + $j.DataField

                    }
                    elseif ($j.IsComputedField -ne $null -and $j.ComputedFieldMethod -ne $null) {

                        # handle case of AxDataEntityViewUnmappedField{PrimitiveType}
                        $field_binding = "METHOD: " + $j.ComputedFieldMethod

                    }
                    else {
                        Write-PSFMessage -Level "Warning" -Message "Unexpected type $typeName"
                    }

                    $outItems = [PsCustomObject][ordered]@{ # create a hash table of the name/value pair
                        Name                  = $element.Name
                        Public                = $element.IsPublic
                        ODataAccessible       = $element.IsPublic
                        PublicCollectionName  = $element.PublicCollectionName
                        StagingTable          = $element.DataManagementStagingTable
                        EntityCategory        = $element.EntityCategory
                        TableGroup            = $element.TableGroup
                        Field_Name            = $j.Name
                        Field_Binding         = $field_binding
                        DataManagementEnabled = $element.DataManagementEnabled
                    }
                    $outItems
                }
            }
        }
    }
}

#
# Recurse on the AxQuerySimpleEmbeddedDataSource array used by DataEntity under the AxQuerySimpleRootDataSource to return an array of objects
#
Function QueryDataSourceRecursion ([Microsoft.Dynamics.AX.Metadata.MetaModel.AxQuerySimpleEmbeddedDataSource[]] $queryDataSources) {

    $datasourceList = @()
    foreach ($datasource in $queryDataSources) {

        $datasourceList += [PsCustomObject]@{ # create a hash table of the name/value pair
            DataSourceName  = $datasource.Name
            DataSourceTable = $datasource.Table
        }

        $datasourceList += QueryDataSourceRecursion $datasource.DataSources
    }

    $datasourceList
}