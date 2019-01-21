
<#
    .SYNOPSIS
        Simple abstraction to handle asynchronous executions
        
    .DESCRIPTION
        Simple abstraction to handle asynchronous executions for several other cmdlets
        
    .PARAMETER Task
        The task you want to work / wait for to complete
        
    .EXAMPLE
        PS C:\> $client = New-Object -TypeName System.Net.Http.HttpClient
        PS C:\> Get-AsyncResult -Task $client.SendAsync($request)
        
        This will take the client (http) and have it send a request using the asynchronous pattern.
        
    .NOTES
        Tags: Async, Waiter, Wait
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-AsyncResult {
    [CmdletBinding()]
    [OutputType('Object')]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [object] $Task
    )

    Write-PSFMessage -Level Verbose -Message "Building the Task Waiter and start waiting." -Target $Task
    $Task.GetAwaiter().GetResult()
}