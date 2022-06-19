
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
        
        MIT License
        
        Copyright (c) Microsoft Corporation.
        
        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:
        
        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.
        
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE
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
                    elseif ($null -ne $j.IsComputedField -and $null -ne $j.ComputedFieldMethod) {

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