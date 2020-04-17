
<#
    .SYNOPSIS
        Get installed package / module from Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Get installed package / module from the machine running the AOS service for Dynamics 365 Finance & Operations
        
    .PARAMETER Name
        Name of the package / module that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all packages / modules
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-D365Module
        
        Shows the entire list of installed packages / modules located in the default location on the machine.
        
    .EXAMPLE
        PS C:\> Get-D365Module -Name "Application*Adaptor"
        
        Shows the list of installed packages / modules where the name fits the search "Application*Adaptor".
        
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
function Get-D365Module {
    [CmdletBinding()]
    param (
        [string] $Name = "*",

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"
        
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Delta.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Diff.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Merge.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Core.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Core.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Storage.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll"))

        Import-AssemblyFileIntoMemory -Path $($Files2Process.ToArray())
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        Write-PSFMessage -Level Verbose -Message "Intializing RuntimeProvider."

        $runtimeProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.Runtime.RuntimeProviderConfiguration -ArgumentList $Script:PackageDirectory
        $metadataProviderFactoryViaRuntime = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
        $metadataProviderViaRuntime = $metadataProviderFactoryViaRuntime.CreateRuntimeProvider($runtimeProviderConfiguration)

        Write-PSFMessage -Level Verbose -Message "MetadataProvider initialized." -Target $metadataProviderViaRuntime

        $modules = $metadataProviderViaRuntime.ModelManifest.ListModules()

        Write-PSFMessage -Level Verbose -Message "Testing if the cmdlet is running on a OneBox or not." -Target $Script:IsOnebox
    
        if ($Script:IsOnebox) {
            Write-PSFMessage -Level Verbose -Message "Machine is onebox. Initializing DiskProvider too."

            $diskProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.DiskProvider.DiskProviderConfiguration
            $diskProviderConfiguration.AddMetadataPath($PackageDirectory)
            $metadataProviderFactoryViaDisk = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
            $metadataProviderViaDisk = $metadataProviderFactoryViaDisk.CreateDiskProvider($diskProviderConfiguration)

            Write-PSFMessage -Level Verbose -Message "MetadataProvider initialized." -Target $metadataProviderViaDisk

            $diskModules = $metadataProviderViaDisk.ModelManifest.ListModules()

            foreach ($module in $diskModules) {
                if ($modules.Name -NotContains $module.Name) {
                    $modules += $module
                }
            }
        }

        Write-PSFMessage -Level Verbose -Message "Looping through all modules."

        foreach ($obj in $($modules | Sort-Object Name)) {
            Write-PSFMessage -Level Verbose -Message "Filtering out all modules that doesn't match the model search." -Target $obj
            if ($obj.Name -NotLike $Name) { continue }

            $res = [Ordered]@{
                Module     = $obj.Name
            }

            $modulepath = Join-Path (Join-Path $PackageDirectory $obj.Name) "bin"

            if (Test-Path -Path $modulepath -PathType Container) {
                $fileversion = Get-FileVersion -Path (Get-ChildItem $modulepath -Filter "Dynamics.AX.$($obj.Name).dll").FullName
                $version = $fileversion.FileVersion
                $versionUpdated = $fileversion.FileVersionUpdated
            }
            else {
                $version = ""
                $versionUpdated = ""
            }

            $res.Version = $version
            $res.VersionUpdated = $versionUpdated
            $res.References = $obj.References
            
            [PSCustomObject]$res
        }
    }
}