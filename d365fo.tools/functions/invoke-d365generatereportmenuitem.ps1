
<#
    .SYNOPSIS
        Generate Report for Menu Item
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all types of Menu Items and generate a metadata report
        
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
        PS C:\> Invoke-D365GenerateReportMenuItem
        
        This will generate a report.
        It will contain all the metadata and save it into a xlsx (Excel) file.
        It will saved the file to "c:\temp\d365fo.tools\"
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
function Invoke-D365GenerateReportMenuItem {
    [CmdletBinding()]
    param (
        [string] $OutputPath = $Script:DefaultTempPath,

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        $outputFile = Join-Path -Path $OutputPath -ChildPath "MenuItems.xlsx"

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
        
        Write-PSFMessage -Level Verbose -Message "Getting all Menu Items (Display) via the metadata provider."
        $displayMenuItemModelInfos = $metadataProvider.MenuItemDisplays.GetPrimaryKeysWithModelInfo()

        $menuItems = New-Object System.Collections.Generic.List[object]

        foreach ($tuple in $displayMenuItemModelInfos) {
            $elementName = $tuple.Item1

            Write-PSFMessage -Level Verbose -Message "Working on: $elementName (MenuItemDisplay)" -Target $elementName

            $modelInfoNames = $tuple.Item2 | Select-Object -ExpandProperty Name # convert list of ModelInfo objects to list of Names
            $modelNames = [string]::Join("; ", $modelInfoNames);

            $element = $metadataProvider.MenuItemDisplays.Read($elementName)

            $outItems = [PsCustomObject][ordered]@{ # create a hash table of the name/value pair
                Name         = $element.Name
                MenuItemType = "Display"
                Models       = $modelNames
                ObjectType   = $element.ObjectType
                Object       = $element.Object
                ConfigKey    = $element.ConfigurationKey
                Enabled      = $element.Enabled
                LabelID      = $element.Label
                Label        = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
            }

            $menuItems.Add($outItems)
        }

        Write-PSFMessage -Level Verbose -Message "Getting all Menu Items (Action) via the metadata provider."
        $actionMenuItemModelInfos = $metadataProvider.MenuItemActions.GetPrimaryKeysWithModelInfo()

        foreach ($tuple in $actionMenuItemModelInfos) {
            $elementName = $tuple.Item1

            Write-PSFMessage -Level Verbose -Message "Working on: $elementName (MenuItemAction)" -Target $elementName

            $modelInfoNames = $tuple.Item2 | Select-Object -ExpandProperty Name # convert list of ModelInfo objects to list of Names
            $modelNames = [string]::Join("; ", $modelInfoNames);

            $element = $metadataProvider.MenuItemActions.Read($elementName)

            $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
                Name         = $element.Name
                MenuItemType = "Action"
                Models       = $modelNames
                ObjectType   = $element.ObjectType
                Object       = $element.Object
                ConfigKey    = $element.ConfigurationKey
                Enabled      = $element.Enabled
                LabelID      = $element.Label
                Label        = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
            }

            $menuItems.Add($outItems)
        }
    
        Write-PSFMessage -Level Verbose -Message "Getting all Menu Items (Output) via the metadata provider."
        $outputMenuItemModelInfos = $metadataProvider.MenuItemOutputs.GetPrimaryKeysWithModelInfo()

        foreach ($tuple in $outputMenuItemModelInfos) {
            $elementName = $tuple.Item1

            Write-PSFMessage -Level Verbose -Message "Working on: $elementName (MenuItemOutput)" -Target $elementName

            $modelInfoNames = $tuple.Item2 | Select-Object -ExpandProperty Name # convert list of ModelInfo objects to list of Names
            $modelNames = [string]::Join("; ", $modelInfoNames);

            $element = $metadataProvider.MenuItemOutputs.Read($elementName)

            $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
                Name         = $element.Name
                MenuItemType = "Output"
                Models       = $modelNames
                ObjectType   = $element.ObjectType
                Object       = $element.Object
                ConfigKey    = $element.ConfigurationKey
                Enabled      = $element.Enabled
                LabelID      = $element.Label
                Label        = [Microsoft.Dynamics.Ax.Xpp.LabelHelper]::GetLabel($element.Label)
            }

            $menuItems.Add($outItems)
        }
        
        $reportName = "MenuItems"
        $sheetName = "$reportName`_$version"
        $sheetName = $sheetName.subString(0, [System.Math]::Min(31, $sheetName.Length))

        $menuItems | Sort-Object Name | Export-Excel -Path $outputFile -WorksheetName $sheetName -ClearSheet -AutoSize -TableName $reportName

        [PSCustomObject]@{
            Report = $reportName
            File     = $outputFile
            Filename = (Split-Path $outputFile -Leaf)
        }
    }
}