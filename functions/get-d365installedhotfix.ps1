<#
.SYNOPSIS
Get installed hotfix

.DESCRIPTION
Get all relevant details for installed hotfix

.PARAMETER Path
Path to the PackagesLocalDirectory

Default path is the same as the aos service packageslocaldirectory 

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
Get-D365InstalledHotfix

This will display all installed hotfixes found on this machine

.EXAMPLE
Get-D365InstalledHotfix -Model "*retail*"

This will display all installed hotfixes found for all models that matches the 
search for "*retail*" found on this machine

.EXAMPLE
Get-D365InstalledHotfix -Model "*retail*" -KB "*43*"

This will display all installed hotfixes found for all models that matches the 
search for "*retail*" and only with KB's that matches the search for "*43*"
 found on this machine

.NOTES
This cmdlet is inspired by the work of "Ievgen Miroshnikov" (twitter: @IevgenMir)

All credits goes to him for showing how to extract these informations

His blog can be found here:
https://ievgensaxblog.wordpress.com

The specific blog post that we based this cmdlet on can be found here:
https://ievgensaxblog.wordpress.com/2017/11/17/d365foe-get-list-of-installed-metadata-hotfixes-using-metadata-api/

#>
function Get-D365InstalledHotfix {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $Path = "$Script:BinDir\bin",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )] 
        [string] $Model = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )] 
        [string] $Name = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )] 
        [string] $KB = "*"

    )

    begin {
    }

    process {
        $StorageAssembly = Join-Path $Path "Microsoft.Dynamics.AX.Metadata.Storage.dll"
        $InstrumentationAssembly = Join-Path $Path "Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll"

        if (Test-Path -Path $StorageAssembly -PathType Leaf) {
            Add-Type -Path $StorageAssembly
        }
        else {
            Write-Error "Unable to load necessary assembly. Ensure that the path is pointing to a valid D365FO folder" -ErrorAction Stop
        }

        if (Test-Path -Path $InstrumentationAssembly -PathType Leaf) {
            Add-Type -Path $InstrumentationAssembly
        }
        else {
            Write-Error "Unable to load necessary assembly. Ensure that the path is pointing to a valid D365FO folder" -ErrorAction Stop
        }

        if ($Script:IsOnebox) {
            $diskProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.DiskProvider.DiskProviderConfiguration
            $diskProviderConfiguration.AddMetadataPath($Script:PackageDirectory)
            $metadataProvicerFactory = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
            $metadataProvider = $metadataProvicerFactory.CreateDiskProvider($diskProviderConfiguration)
        }
        else {
            $runtimeProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.Runtime.RuntimeProviderConfiguration -ArgumentList $Script:PackageDirectory
            $metadataProvicerFactory = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
            $metadataProvider = $metadataProvicerFactory.CreateRuntimeProvider($runtimeProviderConfiguration)
        }

        $updateProvider = $metadataProvider.Updates

        foreach ($obj in $metadataProvider.ModelManifest.ListModules()) {
            if ($obj.Name -NotLike $Model) {continue}

            foreach ($objUpdate in $updateProvider.ListObjects($obj.Name)) {
                $axUpdateObject = $updateProvider.Read($objUpdate)

                if ($axUpdateObject.Name -NotLike $Name) {continue}

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