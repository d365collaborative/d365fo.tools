
<#
    .SYNOPSIS
        Stop an Event Trace session
        
    .DESCRIPTION
        Stop an Event Trace session that you have started earlier with the d365fo.tools
        
    .PARAMETER SessionName
        Name of the tracing session that you want to stop
        
        Default value is "d365fo.tools.trace"
        
    .EXAMPLE
        PS C:\> Stop-D365EventTrace
        
        This will stop an Event Trace session.
        It will use the "d365fo.tools.trace" as the SessionName parameter.
        
    .NOTES
        Tags: ETL, EventTracing, EventTrace
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet/function was inspired by the work of Michael Stashwick (@D365Stuff)
        
        He blog is located here: https://www.d365stuff.co/
        
        and the blogpost that pointed us in the right direction is located here: https://www.d365stuff.co/trace-batch-jobs-and-more-via-cmd-logman/
#>

function Stop-D365EventTrace {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [string] $SessionName = "d365fo.tools.trace"
    )

    end {
        Write-PSFMessage -Level Verbose -Message "Stopping the trace" -Target $SessionName
        
        Stop-Trace -SessionName $SessionName -ETS
    }
}