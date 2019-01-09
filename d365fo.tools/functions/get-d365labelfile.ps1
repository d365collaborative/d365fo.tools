
<#
    .SYNOPSIS
        Get installed package / module from Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Get installed package / module from the machine running the AOS service for Dynamics 365 Finance & Operations
        
    .PARAMETER Name
        Name of the package / module that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all packages / modules
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-D365Module
        
        Shows the entire list of installed packages / modules located in the default location on the machine
        
    .EXAMPLE
        PS C:\> Get-D365Module -Name "Application*Adaptor"
        
        Shows the list of installed packages / modules where the name fits the search "Application*Adaptor"
        
        A result set example:
        ApplicationFoundationFormAdaptor
        ApplicationPlatformFormAdaptor
        ApplicationSuiteFormAdaptor
        ApplicationWorkspacesFormAdaptor
        
    .EXAMPLE
        PS C:\> Get-D365Module -PackageDirectory "J:\AOSService\PackagesLocalDirectory"
        
        Shows the entire list of installed packages / modules located in "J:\AOSService\PackagesLocalDirectory" on the machine
        
    .NOTES
        Tags: PackagesLocalDirectory, Servicing, Model, Models, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
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

        if($Name.Substring($Name.Length -1, 1) -ne "*") {$Name = "$Name*"}
        
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

                if ($objLabelFile -NotLike $Name) {continue}

                $labelId = $objLabelFile.Substring(0, $objLabelFile.LastIndexOf("_"))
                $langString = $objLabelFile.Substring($objLabelFile.LastIndexOf("_") + 1)

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