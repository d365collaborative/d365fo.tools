
<#
    .SYNOPSIS
        Invoke the Invoke-RestMethod, wrapped in a handler that helps with the 429 issues
        
    .DESCRIPTION
        A http endpoint will push back on clients, if it feels overwhelmed
        
        This translates into 429 in the status code of the http call and requires local logic to respect the retry timeout advice sent back
        
    .PARAMETER Method
        The http method that you want to utilize
        
    .PARAMETER Uri
        The Uri for the endpoint that you want to work against
        
    .PARAMETER ContentType
        The content type value that you want to utilize while working against the endpoint
        
    .PARAMETER Payload
        The payload, if any, that you want to pass to the endpoint
        
    .PARAMETER Headers
        Headers to be used against the endpoint
        
    .PARAMETER RetryTimeout
        The retry timeout, before the cmdlet should quit retrying based on the 429 status code
        
        Needs to be provided in the timspan notation:
        "hh:mm:ss"
        
        hh is the number of hours, numerical notation only
        mm is the number of minutes
        ss is the numbers of seconds
        
        Each section of the timeout has to valid, e.g.
        hh can maximum be 23
        mm can maximum be 59
        ss can maximum be 59
        
        Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint
        
    .EXAMPLE
        PS C:\> Invoke-RequestHandler -Method "Post" -Uri 'https://lcsapi.lcs.dynamics.com/environment/v1/stop/project/123456789/environment/d5bbfe74-8b0f-4b5a-afd9-58b19948e5c9' -ContentType "application/json" -Headers @{Authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi....." }
        
        This will post/invoke the stop action for a given environnment in LCS API endpoint.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-RequestHandler {
    [CmdletBinding()]
    param (
        [Alias("HttpMethod")]
        [string] $Method,

        [string] $Uri,
        
        [string] $ContentType,

        [string] $Payload,

        [Hashtable] $Headers,

        [Timespan] $RetryTimeout = "00:00:00"
    )
    
    begin {
        $parms = @{}
        $parms.Method = $Method
        $parms.Uri = $Uri
        $parms.Headers = $Headers
        $parms.ContentType = $ContentType

        if ($Payload) {
            $parms.Body = $Payload
        }

        $start = (Get-Date)
        $handleTimeout = $false

        if ($RetryTimeout.Ticks -gt 0) {
            $handleTimeout = $true
        }
    }
    
    process {
        $429Attempts = 0

        do {
            $429Retry = $false

            try {
                Invoke-RestMethod @parms
            }
            catch [System.Net.WebException] {
                if ($_.exception.response.statuscode -eq 429) {
                    $429Retry = $true
                    
                    $retryWaitSec = $_.exception.response.Headers["Retry-After"]

                    if (-not ($retryWaitSec -gt 0)) {
                        $retryWaitSec = 10
                    }

                    if ($handleTimeout) {
                        $timeSinceStart = New-TimeSpan -End $(Get-Date) -Start $start
                        $timeWithWait = $timeSinceStart.Add([timespan]::FromSeconds($retryWaitSec))
                        
                        $temp = $RetryTimeout - $timeWithWait

                        if ($temp.Ticks -lt 0) {
                            #We will be exceeding the timeout limit
                            $messageString = "The timeout value suggested from the endpoint will exceed the RetryTimeout (<c='em'>$RetryTimeout</c>) threshold."
                            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $entity
                            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
                            return
                        }
                    }

                    Write-PSFMessage -Level Host -Message "Hit a 429 status code. Will wait for: <c='em'>$retryWaitSec</c> seconds before trying again. Attempt (<c='em'>$429Attempts</c>)"
                    Start-Sleep -Seconds $retryWaitSec
                    $429Attempts++
                }
                else {
                    Throw
                }
            }
        } while ($429Retry)
    }
}