
<#
    .SYNOPSIS
        Retrieve sync base and extension elements based on a modulename
        
    .DESCRIPTION
        Retrieve the list of installed packages / modules where the name fits the ModuleName parameter.
        For every model retrieved: collect all base sync and extension sync elements.
        
    .PARAMETER ModuleName
        Name of the module that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all modules
        
    .EXAMPLE
        PS C:\> Get-SyncElements -ModuleName "Application*Adaptor"
        
        Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".
        For every model retrieved: collect all base sync and extension sync elements.
        
    .NOTES
        Tags: Database
        
        Author: Jasper Callens - Cegeka
        
#>
function Get-SyncElements {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $ModuleName
    )

    begin {
        $assemblies2Process = New-Object -TypeName "System.Collections.ArrayList"
                
        $null = $assemblies2Process.Add((Join-Path $BinDirTools "Microsoft.Dynamics.AX.Metadata.dll"))
        $null = $assemblies2Process.Add((Join-Path $BinDirTools "Microsoft.Dynamics.AX.Metadata.Core.dll"))
        $null = $assemblies2Process.Add((Join-Path $BinDirTools "Microsoft.Dynamics.AX.Metadata.Storage.dll"))
        $null = $assemblies2Process.Add((Join-Path $BinDirTools "Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll"))
        $null = $assemblies2Process.Add((Join-Path $BinDirTools "Microsoft.Dynamics.AX.Metadata.Management.Delta.dll"))
        $null = $assemblies2Process.Add((Join-Path $BinDirTools "Microsoft.Dynamics.AX.Metadata.Management.Core.dll"))
        $null = $assemblies2Process.Add((Join-Path $BinDirTools "Microsoft.Dynamics.AX.Metadata.Management.Merge.dll"))
        $null = $assemblies2Process.Add((Join-Path $BinDirTools "Microsoft.Dynamics.AX.Metadata.Management.Diff.dll"))

        Import-AssemblyFileIntoMemory -Path $($assemblies2Process.ToArray())

        $runtimeMetadataProvider = (New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory).CreateRuntimeProvider($Script:PackageDirectory)

        $baseSyncElements = New-Object -TypeName "System.Collections.ArrayList"
        $extensionSyncElements = New-Object -TypeName "System.Collections.ArrayList"

        $extensionToBaseSyncElements = New-Object -TypeName "System.Collections.ArrayList"
    }

    process {
        Write-PSFMessage -Level Debug -Message "Collecting $ModuleName AOT elements to sync"

        $baseSyncElements.AddRange($runtimeMetadataProvider.Tables.ListObjects($ModuleName));
        $baseSyncElements.AddRange($runtimeMetadataProvider.Views.ListObjects($ModuleName));
        $baseSyncElements.AddRange($runtimeMetadataProvider.DataEntityViews.ListObjects($ModuleName));

        $extensionSyncElements.AddRange($runtimeMetadataProvider.TableExtensions.ListObjects($ModuleName));

        # Some Extension elements have to be 'converted' to their base element that has to be passed to the SyncList of the syncengine
        # Add these elements to an ArrayList
        $extensionToBaseSyncElements.AddRange($runtimeMetadataProvider.ViewExtensions.ListObjects($ModuleName));
        $extensionToBaseSyncElements.AddRange($runtimeMetadataProvider.DataEntityViewExtensions.ListObjects($ModuleName));
    }

    end {
        # Loop every extension element, convert it to its base element and add the base element to another list
        Foreach ($extElement in $extensionToBaseSyncElements) {
            $null = $baseSyncElements.Add($extElement.Substring(0, $extElement.IndexOf('.')))
        }

        Write-PSFMessage -Level Debug -Message "Elements from $ModuleName retrieved: $(($baseSyncElements + $extensionSyncElements) -join ",")"

        [PSCustomObject]@{
            BaseSyncElements = $baseSyncElements.ToArray();
            ExtensionSyncElements = $extensionSyncElements.ToArray();
        }
    }
}