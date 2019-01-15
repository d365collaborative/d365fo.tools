
<#
    .SYNOPSIS
        Handle time measurement
        
    .DESCRIPTION
        Handle time measurement from when a cmdlet / function starts and ends
        
        Will write the output to the verbose stream (Write-PSFMessage -Level Verbose)
        
    .PARAMETER Start
        Switch to instruct the cmdlet that a start time registration needs to take place
        
    .PARAMETER End
        Switch to instruct the cmdlet that a time registration has come to its end and it needs to do the calculation
        
    .EXAMPLE
        PS C:\> Invoke-TimeSignal -Start
        
        This will start the time measurement for any given cmdlet / function
        
    .EXAMPLE
        PS C:\> Invoke-TimeSignal -End
        
        This will end the time measurement for any given cmdlet / function.
        The output will go into the verbose stream.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-TimeSignal {
    [CmdletBinding(DefaultParameterSetName = 'Start')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Start', Position = 1 )]
        [switch] $Start,
        
        [Parameter(Mandatory = $True, ParameterSetName = 'End', Position = 2 )]
        [switch] $End
    )

    $Time = (Get-Date)

    $Command = (Get-PSCallStack)[1].Command

    if ($Start) {
        if ($Script:TimeSignals.ContainsKey($Command)) {
            Write-PSFMessage -Level Verbose -Message "The command '$Command' was already taking part in time measurement. The entry has been update with current date and time."
            $Script:TimeSignals[$Command] = $Time
        }
        else {
            $Script:TimeSignals.Add($Command, $Time)
        }
    }
    else {
        if ($Script:TimeSignals.ContainsKey($Command)) {
            $TimeSpan = New-TimeSpan -End $Time -Start (($Script:TimeSignals)[$Command])

            Write-PSFMessage -Level Verbose -Message "Total time spent inside the function was $TimeSpan" -Target $TimeSpan -FunctionName $Command -Tag "TimeSignal"
            $null = $Script:TimeSignals.Remove($Command)
        }
        else {
            Write-PSFMessage -Level Verbose -Message "The command '$Command' was never started to take part in time measurement."
        }
    }
}