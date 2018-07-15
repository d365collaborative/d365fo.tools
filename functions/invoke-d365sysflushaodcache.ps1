<#
.SYNOPSIS
Invoke the SysFlushAos class

.DESCRIPTION
Invoke the runnable class SysFlushAos to clear the AOD cache

.EXAMPLE
Invoke-D365SysFlushAodCache

.NOTES
General notes
#>
function Invoke-D365SysFlushAodCache {
    [CmdletBinding()]
    param ()

    Invoke-D365SysRunnerClass -ClassName "SysFlushAOD"
}