
<#
    .SYNOPSIS
        Start or stop a given environment using LCS
        
    .DESCRIPTION
        Start or stop a specified IAAS environment that is Customer Managed through the LCS API.
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to take action upon
        
        The Id can be located inside the LCS portal
        
    .PARAMETER IsStop
        When set to True, the environment will be stopped. When set to False, the environment will be started.
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        The value depends on where your LCS project is located. There are multiple valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.no.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
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
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Start-LcsEnvironmentStartStopV2 -ProjectId 123456789 -EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -IsStop $False -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will trigger the environment start operation upon the given environment through the LCS API.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
    .EXAMPLE
        PS C:\> Start-LcsEnvironmentStartStopV2 -ProjectId 123456789 -EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -IsStop $True -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will trigger the environment stop operation upon the given environment through the LCS API.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
    .NOTES
        Tags: Environment, Stop, Start, LCS, Api, AAD, Token
        
        Author: Mötz Jensen (@Splaxi), Billy Richardson (@richardsondev)
#>

function Start-LcsEnvironmentStartStopV2 {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
    
        [Parameter(Mandatory = $true)]
        [Alias('Token')]
        [string] $BearerToken,
        
        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,

        [Parameter(Mandatory = $true)]
        [boolean] $IsStop,

        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    begin {
        Invoke-TimeSignal -Start
        
        $internalAction = "start";
    
        if ($IsStop -eq $True) {
            $internalAction = "stop";
        }
    
        $headers = @{
            "Authorization" = "$BearerToken"
        }

        $parms = @{}
        $parms.Method = "POST"
        $parms.Uri = "$LcsApiUri/environment/v1/$($internalAction)/project/$($ProjectId)/environment/$($EnvironmentId)"
        $parms.Headers = $headers
        $parms.RetryTimeout = $RetryTimeout
    }

    process {
        try {
            Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
            Invoke-RequestHandler @parms
        }
        catch [System.Net.WebException] {
            Write-PSFMessage -Level Host -Message "Error status code <c='em'>$($_.exception.response.statuscode)</c> in starting a new deployment in LCS. <c='em'>$($_.exception.response.StatusDescription)</c>." -Exception $PSItem.Exception -Target $_
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }

        Invoke-TimeSignal -End
    }
}