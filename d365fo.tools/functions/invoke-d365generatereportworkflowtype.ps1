
<#
    .SYNOPSIS
        Generate Report for Workflow Type
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all Workflow Types and generate a metadata report
        
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
        PS C:\> Invoke-D365GenerateReportWorkflowType
        
        This will generate a report.
        It will contain all the metadata and save it into a xlsx (Excel) file.
        It will saved the file to "c:\temp\d365fo.tools\"
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
function Invoke-D365GenerateReportWorkflowType {
    [CmdletBinding()]
    param (
        [string] $OutputPath = $Script:DefaultTempPath,

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        $outputFile = Join-Path -Path $OutputPath -ChildPath "WorkflowTypes.xlsx"

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
        $workflowTypesModelInfos = $metadataProvider.WorkflowTemplates.GetPrimaryKeysWithModelInfo()
        
        $workflowTypes = New-Object System.Collections.Generic.List[object]

        foreach ($tuple in $workflowTypesModelInfos) {
            $elementName = $tuple.Item1

            Write-PSFMessage -Level Verbose -Message "Working on: $elementName (WorkflowType)" -Target $elementName

            $element = $metadataProvider.WorkflowTemplates.Read($elementName)

            foreach ($supportedElement in $element.SupportedElements) {
                $outItems = [PsCustomObject][ordered]@{ # create a hash table of the name/value pair
                    Name            = $element.Name
                    Label           = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
                    HelpText        = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.HelpText)
                    AssociationType = $element.AssociationType
                    Category        = $element.Category
                    Participant     = $supportedElement.Name
                    Role            = $supportedElement.Type
                }
            }

            $workflowTypes.Add($outItems)
        }

        $reportName = "WorkflowTypes"
        $sheetName = "$reportName`_$version"
        $sheetName = $sheetName.subString(0, [System.Math]::Min(31, $sheetName.Length))

        $workflowTypes | Sort-Object Name | Export-Excel -Path $outputFile -WorksheetName $sheetName -ClearSheet -AutoSize -TableName $reportName

        [PSCustomObject]@{
            Report   = $reportName
            File     = $outputFile
            Filename = (Split-Path $outputFile -Leaf)
        }
    }
}