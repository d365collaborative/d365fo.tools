
<#
    .SYNOPSIS
        Invoke the one of the data flush classes
        
    .DESCRIPTION
        Invoke one of the runnable classes that is clearing cache, data or something else
        
    .PARAMETER URL
        URL to the Dynamics 365 instance you want to clear the AOD cache on
        
    .PARAMETER Class
        The class that you want to execute.
        
        Default value is "SysFlushAod"
        
    .EXAMPLE
        PS C:\> Invoke-D365DataFlush
        
        This will make a call against the default URL for the machine and
        have it execute the SysFlushAOD class.
        
    .EXAMPLE
        PS C:\> Invoke-D365DataFlush -Class SysFlushData,SysFlushAod
        
        This will make a call against the default URL for the machine and
        have it execute the SysFlushData and SysFlushAod classes.
        
    .NOTES
        Tags: Flush, Url, Servicing
        
        Author: Mötz Jensen (@Splaxi)
#>
function Invoke-D365DataFlush {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1 )]
        [string] $Url,

        [ValidateSet('SysFlushData', 'SysFlushAod', 'SysDataCacheParameters')]
        [string[]] $Class = "SysFlushAod"
    )

    if ($PSBoundParameters.ContainsKey("URL")) {
        foreach ($item in $Class) {
            Write-PSFMessage -Level Verbose -Message "Executing Invoke-D365SysRunnerClass with $item" -Target $item
            Invoke-D365SysRunnerClass -ClassName $item -Url $URL
        }
    }
    else {
        foreach ($item in $Class) {
            Write-PSFMessage -Level Verbose -Message "Executing Invoke-D365SysRunnerClass with $item" -Target $item
            Invoke-D365SysRunnerClass -ClassName $item
        }
    }
}