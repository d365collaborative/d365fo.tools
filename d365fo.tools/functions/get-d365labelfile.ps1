
<#
    .SYNOPSIS
        Get label file (ids) for packages / modules from Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Get label file (ids) for packages / modules from the machine running the AOS service for Dynamics 365 Finance & Operations
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER Module
        Name of the module that you want to work against
        
        Default value is "*" which will search for all modules
        
    .PARAMETER Name
        Name of the label file (id) that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Acc*Receivable*"
        
        Default value is "*" which will search for all label file (ids)
        
    .EXAMPLE
        PS C:\> Get-D365LabelFile
        
        Shows the entire list of label file (ids) for all installed packages / modules located in the default location on the machine
        
    .EXAMPLE
        PS C:\> Get-D365LabelFile -Name "Acc*Receivable*"
        
        Shows the list of label file (ids) for all installed packages / modules where the label file (ids) name fits the search "Acc*Receivable*"
        
        A result set example:
        
        LabelFileId                        Languages              Module
        -----------                        ---------              ------
        AccountsReceivable                 {ar-AE, ar, cs, da...} ApplicationSuite
        AccountsReceivable_SalesTaxCodesSA {en-US}                ApplicationSuite
        
        
    .EXAMPLE
        PS C:\> Get-D365LabelFile -PackageDirectory "J:\AOSService\PackagesLocalDirectory"
        
        Shows the list of label file (ids) for all installed packages / modules located in "J:\AOSService\PackagesLocalDirectory" on the machine
        
    .NOTES
        Tags: PackagesLocalDirectory, Servicing, Language, Labels, Label
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet is inspired by the work of "Pedro Tornich" (twitter: @ptornich)
        
        All credits goes to him for showing how to extract these information
        
        His github repository can be found here:
        https://github.com/ptornich/LabelFileGenerator
        
#>
function Get-D365LabelFile {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $BinDir = "$Script:BinDir\bin",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [string] $PackageDirectory = $Script:PackageDirectory,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 3 )]
        [Alias("ModuleName")]
        [string] $Module = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [string] $Name = "*"
    )

    begin {
    }

    process {
        $files = @((Join-Path -Path $BinDir -ChildPath "Microsoft.Dynamics.AX.Metadata.Storage.dll"),
            (Join-Path -Path $BinDir -ChildPath "Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll"))
        
        if(-not (Test-PathExists -Path $files -Type Leaf)) {
            return
        }

        Add-Type -Path $files

        Write-PSFMessage -Level Verbose -Message "Testing if the cmdlet is running on a OneBox or not." -Target $Script:IsOnebox
        if ($Script:IsOnebox) {
            Write-PSFMessage -Level Verbose -Message "Machine is onebox. Will continue with DiskProvider."

            $diskProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.DiskProvider.DiskProviderConfiguration
            $diskProviderConfiguration.AddMetadataPath($PackageDirectory)
            $metadataProviderFactory = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
            $metadataProvider = $metadataProviderFactory.CreateDiskProvider($diskProviderConfiguration)

            Write-PSFMessage -Level Verbose -Message "MetadataProvider initialized." -Target $metadataProvider
        }
        else {
            Write-PSFMessage -Level Verbose -Message "Machine is NOT onebox. Will continue with RuntimeProvider."

            $runtimeProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.Runtime.RuntimeProviderConfiguration -ArgumentList $Script:PackageDirectory
            $metadataProviderFactory = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
            $metadataProvider = $metadataProviderFactory.CreateRuntimeProvider($runtimeProviderConfiguration)

            Write-PSFMessage -Level Verbose -Message "MetadataProvider initialized." -Target $metadataProvider
        }

        Write-PSFMessage -Level Verbose -Message "Initializing the LabelProvider from the MetadataProvider."
        $labelProvider = $metadataProvider.LabelFiles

        $res = New-Object 'System.Collections.Generic.Dictionary[string, System.Collections.ArrayList]'

        Write-PSFMessage -Level Verbose -Message "Looping through all modules from the MetadataProvider."
        foreach ($obj in $metadataProvider.ModelManifest.ListModules()) {
            Write-PSFMessage -Level Verbose -Message "Filtering out all modules that doesn't match the model search." -Target $obj
            if ($obj.Name -NotLike $Module) {continue}

            Write-PSFMessage -Level Verbose -Message "$($obj.Name)"

            $labelFiles = $labelProvider.ListObjects($obj.Name)

            foreach ($objLabelFile in $labelFiles) {
                Write-PSFMessage -Level Verbose -Message "$($objLabelFile)"

                if($objLabelFile -like "*.*") {
                    $chars = $objLabelFile.ToCharArray()
                    $chars[$objLabelFile.LastIndexOf(".")] = "_"
                    $objLabelFile = $chars -join ""
                }

                $labelId = $objLabelFile.Substring(0, $objLabelFile.LastIndexOf("_"))
                $langString = $objLabelFile.Substring($objLabelFile.LastIndexOf("_") + 1)

                if ($labelId -NotLike $Name) {continue}

                if(-not ($res.ContainsKey($labelId))) {
                    $null = $res.Add($labelId, (New-object -TypeName "System.Collections.ArrayList"))
                }

                $null = $res[$labelId].Add($langString)
            }

            foreach ($item in $res.Keys) {

                [PSCustomObject]@{
                    LabelFileId   = $item
                    Languages  = $res[$item]
                    Module = $obj.Name
                }
            }
            
        }
    }

    end {
    }
}