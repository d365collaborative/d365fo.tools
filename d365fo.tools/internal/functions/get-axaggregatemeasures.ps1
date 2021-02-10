
<#
    .SYNOPSIS
        Get Aggregate Measure
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all Aggregate Measures
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-AxAggregateMeasures
        
        This will get all objects.
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
Function Get-AxAggregateMeasures {
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
        
        $aggregateDimensions = Get-AxAggregateDimensions -BinDir $BinDir -PackageDirectory $PackageDirectory
        $aggregateDimensionsHash = $aggregateDimensions | ArrayToHash
    }

    PROCESS {

        $aggregateMeasurementsModelInfos = $metadataProvider.AggregateMeasurements.GetPrimaryKeysWithModelInfo()
        
        foreach ($tuple in $aggregateMeasurementsModelInfos) {
            $elementName = $tuple.Item1

            $element = $metadataProvider.AggregateMeasurements.Read($elementName)

            foreach ($k in $element.MeasureGroups) {
                $dimensionsArray = @()

                #creates an array of dimensions and their data source in parenthesis per MeasureGroup
                foreach ($i in $k.Dimensions) {
                    $pos = $i.ToString().IndexOf(" ")
                    $i = $i.ToString().Substring(0, $pos)

                    $dimensionsArray += ($i + " (" + $aggregateDimensionsHash[$i].DataSource + ")")
                }
                
                $outItems = [PsCustomObject][ordered]@{ # create a hash table of the name/value pair
                    Name                   = $element.Name
                    MeasureGroup           = $k.Name
                    MeasureGroupDataSource = $k.Table
                    Measures               = [String]::join(", ", $k.Measures)
                    Dimensions             = [String]::join(", ", $dimensionsArray)
                }

                $outItems
            }
        }
    }
}

Function ArrayToHash {
    param()
    begin { $hash = @{} }
    process { $hash[$_.Name] = $_ }
    end { return $hash }
}