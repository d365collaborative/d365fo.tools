
<#
    .SYNOPSIS
        Import assemblies needed for the metat report generation
        
    .DESCRIPTION
        Import all assemblies that are needed to work with the meta data provider for all related objects
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .EXAMPLE
        PS C:\> Import-GenerateReportAssemblies
        
        This will import all needed assemblies into memory.
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
function Import-GenerateReportAssemblies {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param (
        [string] $BinDir = "$Script:BinDir\bin"
    )
    
    end {
        $Files2Process = New-Object System.Collections.Generic.List[string]
        
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Delta.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Diff.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Merge.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Core.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Core.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Storage.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Extensions.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Server.Core.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Xpp.AxShared.dll"))
        $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Xpp.Support.dll"))

        Import-AssemblyFileIntoMemory -Path $($Files2Process.ToArray())
    }
}