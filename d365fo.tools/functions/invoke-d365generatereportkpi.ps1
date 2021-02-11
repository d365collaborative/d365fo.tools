
<#
    .SYNOPSIS
        Generate Report for KPI
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all KPIs and generate a metadata report
        
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
        PS C:\> Invoke-D365GenerateReportKpi
        
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
function Invoke-D365GenerateReportKpi {
    [CmdletBinding()]
    param (
        [string] $OutputPath = $Script:DefaultTempPath,

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        $outputFile = Join-Path -Path $OutputPath -ChildPath "KPIs.xlsx"

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
        
        Write-PSFMessage -Level Verbose -Message "Getting all KPIs via the metadata provider."
        $KPIModelInfos = $metadataProvider.KPIs.GetPrimaryKeysWithModelInfo()

        $KPIs = New-Object System.Collections.Generic.List[object]

        foreach ($tuple in $KPIModelInfos) {
            $elementName = $tuple.Item1
    
            Write-PSFMessage -Level Verbose -Message "Working on: $elementName (KPI)" -Target $elementName
            
            $element = $metadataProvider.KPIs.Read($elementName)
    
            if ($element.Name -eq "FMRevenue") {
                $calcMeasure = $element.Value.Measure
                $calcMeasureGroup = $element.Value.MeasureGroup
            }
            else {
                $calcMeasure = $element.Goal.Measure
                $calcMeasureGroup = $element.Goal.MeasureGroup
            }
    
            $outItems = [PsCustomObject][ordered]@{ # create a hash table of the name/value pair
                Name                   = $element.Name
                Label                  = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
                Measurement            = $element.Measurement
                ValueType              = $element.Value.ValueType
                GoalType               = $element.Goal.GoalType
                Value                  = $element.goal.Value
                CalculatedMeasure      = $calcMeasure
                CalculatedMeasureGroup = $calcMeasureGroup
                FormExposed            = ""
                WorkspaceExposed       = ""
            }
    
            $KPIs.Add($outItems)
        }
        
        $reportName = "KPIs"
        $sheetName = "$reportName`_$version"
        $sheetName = $sheetName.subString(0, [System.Math]::Min(31, $sheetName.Length))

        $KPIs | Sort-Object Name | Export-Excel -Path $outputFile -WorksheetName $sheetName -ClearSheet -AutoSize -TableName $reportName

        [PSCustomObject]@{
            Report = $reportName
            File     = $outputFile
            Filename = (Split-Path $outputFile -Leaf)
        }
    }
}