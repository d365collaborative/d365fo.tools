
<#
    .SYNOPSIS
        Clear the monitoring data from a Dynamics 365 for Finance & Operations machine
        
    .DESCRIPTION
        Clear the monitoring data that is filling up the service drive on a Dynamics 365 for Finance & Operations
        
    .PARAMETER Path
        The path to where the monitoring data is located
        
        The default value is the "ServiceDrive" (j:\ | k:\) and the \MonAgentData\SingleAgent\Tables folder structure
        
    .EXAMPLE
        PS C:\> Clear-D365MonitorData
        
        This will delete all the files that are located in the default path on the machine.
        Some files might be locked by a process, but the cmdlet will attemp to delete all files.
        
    .NOTES
        Tags: Monitor, MonitorData, MonitorAgent, CleanUp, Servicing
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Clear-D365MonitorData {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string] $Path = (Join-Path $script:ServiceDrive "\MonAgentData\SingleAgent\Tables")
    )
    
    process {
        Get-ChildItem -Path $Path | Remove-Item -Force -ErrorAction SilentlyContinue
    }
}