
<#
    .SYNOPSIS
        Generate Report for Table
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all Tables and generate a metadata report
        
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
        PS C:\> Invoke-D365GenerateReportTable
        
        This will generate a report.
        It will contain all the metadata and save it into a xlsx (Excel) file.
        It will saved the file to "c:\temp\d365fo.tools\"
        
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
function Invoke-D365GenerateReportTable {
    [CmdletBinding()]
    param (
        [string] $OutputPath = $Script:DefaultTempPath,

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        $outputFile = Join-Path -Path $OutputPath -ChildPath "Tables.xlsx"

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

        Write-PSFMessage -Level Warning -Message "Generating the Table report will take a long time. If you want to see progress while it is working, use the -Verbose parameter option"
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        
        $dataEntities = Get-AxDataEntities -BinDir $BinDir -PackageDirectory $PackageDirectory
        $forms = Get-AxForms -BinDir $BinDir -PackageDirectory $PackageDirectory
        $views = Get-AxViews -BinDir $BinDir -PackageDirectory $PackageDirectory

        Write-PSFMessage -Level Verbose -Message "Getting all SSRS Reports via the metadata provider."
        $tablesModelInfos = $metadataProvider.Tables.GetPrimaryKeysWithModelInfo()

        #declare variables
        $entityOrView
        $crossCompany = ""
    
        $tables = New-Object System.Collections.Generic.List[object]

        foreach ($tuple in $tablesModelInfos) {
            $elementName = $tuple.Item1

            Write-PSFMessage -Level Verbose -Message "Working on: $elementName (Table)" -Target $elementName

            $element = $metadataProvider.Tables.Read($elementName)

            #check if table is used in an entity
            $entityMatch = "No"
            foreach ($i in $dataEntities) {
                if ($i.DataSource) {
                    if ($i.DataSource.StartsWith($element.Name + " [")) {
                        $entityMatch = "Yes"
                    }
                }
            }

            #check if table is used in a view
            $viewMatch = "No"
            foreach ($i in $views) {
                foreach ($k in $i.DataSources) {
                  
                    if ($element.Name -eq $k.Name) {
                        $viewMatch = "Yes"
                    }
                }
            }

            if ($viewMatch -eq "Yes" -or $entityMatch -eq "Yes") {
                $entityOrView = "Yes"
            }
            else {
                $entityOrView = "No"
            }

            #check if form's data source is the table and then taking CrossCompanyAutoQuery property
            foreach ($i in $forms) {
                foreach ($k in $i.DataSources) {
                    if ($k.Name -eq $element.Name) {
                        $crossCompany = $k.CrossCompanyAutoQuery
                        if ($crossCompany -eq "") {
                            $crossCompany = "No"
                        }
                    }
                }
            }

            $outItems = [PsCustomObject][ordered]@{ # create a hash table of the name/value pair
                Name         = $element.Name
                TableGroup   = $element.TableGroup
                CrossCompany = $crossCompany
                SystemTable  = $element.SystemTable
                Indexes      = [string]::Join(", ", $element.Indexes)
                EntityOrView = $entityOrView
            }

            $tables.Add($outItems)
        }

        $reportName = "Tables"
        $sheetName = "$reportName`_$version"
        $sheetName = $sheetName.subString(0, [System.Math]::Min(31, $sheetName.Length))

        $tables | Sort-Object Name | Export-Excel -Path $outputFile -WorksheetName $sheetName -ClearSheet -AutoSize -TableName $reportName

        [PSCustomObject]@{
            Report = $reportName
            File     = $outputFile
            Filename = (Split-Path $outputFile -Leaf)
        }
    }
}