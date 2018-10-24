
<#
    .SYNOPSIS
        Invoke the SysFlushAos class
        
    .DESCRIPTION
        Invoke the runnable class SysFlushAos to clear the AOD cache
        
    .PARAMETER URL
        URL to the Dynamics 365 instance you want to clear the AOD cache on
        
    .EXAMPLE
        PS C:\> Invoke-D365SysFlushAodCache
        
        This will a call against the default URL for the machine and
        have it execute the SysFlushAOD class
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-D365SysFlushAodCache {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1 )]
        [string] $Url
    )

    if ($PSBoundParameters.ContainsKey("URL")) {
        Invoke-D365SysRunnerClass -ClassName "SysFlushAOD" -Url $URL
    }
    else {
        Invoke-D365SysRunnerClass -ClassName "SysFlushAOD"
    }
}