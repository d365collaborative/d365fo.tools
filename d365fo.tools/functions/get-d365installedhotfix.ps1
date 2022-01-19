
<#
    .SYNOPSIS
        Get installed hotfix (DEPRECATED)
        
    .DESCRIPTION
        Get all relevant details for installed hotfixes on environments that are not on a "One Version" version. This cmdlet is deprecated since 2021-10-05 and will be removed by 2022-04-05.
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS Service PackagesLocalDirectory\bin
        
    .PARAMETER PackageDirectory
        Path to the PackagesLocalDirectory
        
        Default path is the same as the AOS Service PackagesLocalDirectory
        
    .PARAMETER Model
        Name of the model that you want to work against
        
        Accepts wildcards for searching. E.g. -Model "*Retail*"
        
        Default value is "*" which will search for all models
        
    .PARAMETER Name
        Name of the hotfix that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "7045*"
        
        Default value is "*" which will search for all hotfixes
        
    .PARAMETER KB
        KB number of the hotfix that you are looking for
        
        Accepts wildcards for searching. E.g. -KB "4045*"
        
        Default value is "*" which will search for all KB's
        
    .EXAMPLE
        PS C:\> Get-D365InstalledHotfix
        
        This will display all installed hotfixes found on this machine
        
    .EXAMPLE
        PS C:\> Get-D365InstalledHotfix -Model "*retail*"
        
        This will display all installed hotfixes found for all models that matches the search for "*retail*" found on this machine
        
    .EXAMPLE
        PS C:\> Get-D365InstalledHotfix -Model "*retail*" -KB "*43*"
        
        This will display all installed hotfixes found for all models that matches the search for "*retail*" and only with KB's that matches the search for "*43*" found on this machine
        
    .NOTES
        Tags: Hotfix, Servicing, Model, Models, KB, Patch, Patching, PackagesLocalDirectory
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet is inspired by the work of "Ievgen Miroshnikov" (twitter: @IevgenMir)
        
        All credits goes to him for showing how to extract these information
        
        His blog can be found here:
        https://ievgensaxblog.wordpress.com
        
        The specific blog post that we based this cmdlet on can be found here:
        https://ievgensaxblog.wordpress.com/2017/11/17/d365foe-get-list-of-installed-metadata-hotfixes-using-metadata-api/
        
#>
function Get-D365InstalledHotfix {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $BinDir = "$Script:BinDir\bin",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [string] $PackageDirectory = $Script:PackageDirectory,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [string] $Model = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [string] $Name = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 5 )]
        [string] $KB = "*"

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

        Write-PSFMessage -Level Verbose -Message "Initializing the UpdateProvider from the MetadataProvider."
        $updateProvider = $metadataProvider.Updates

        Write-PSFMessage -Level Verbose -Message "Looping through all modules from the MetadataProvider."
        foreach ($obj in $metadataProvider.ModelManifest.ListModules()) {
            Write-PSFMessage -Level Verbose -Message "Filtering out all modules that doesn't match the model search." -Target $obj
            if ($obj.Name -NotLike $Model) {continue}

            Write-PSFMessage -Level Verbose -Message "Looping through all hotfixes for the module from the UpdateProvider." -Target $obj
            foreach ($objUpdate in $updateProvider.ListObjects($obj.Name)) {
                Write-PSFMessage -Level Verbose -Message "Reading all details for the hotfix through UpdateProvider." -Target $objUpdate
                
                $axUpdateObject = $updateProvider.Read($objUpdate)

                Write-PSFMessage -Level Verbose -Message "Filtering out all hotfixes that doesn't match the name search." -Target $axUpdateObject
                if ($axUpdateObject.Name -NotLike $Name) {continue}

                Write-PSFMessage -Level Verbose -Message "Filtering out all hotfixes that doesn't match the KB search." -Target $axUpdateObject
                if ($axUpdateObject.KBNumbers -NotLike $KB) {continue}

                [PSCustomObject]@{
                    Model   = $obj.Name
                    Hotfix  = $axUpdateObject.Name
                    Applied = $axUpdateObject.AppliedDateTime
                    KBs     = $axUpdateObject.KBNumbers
                }
            }
        }
    }

    end {
    }
}