
<#
    .SYNOPSIS
        Get LCS environment rsat certificate from within a project
        
    .DESCRIPTION
        Download and persist the active rsat certificate from environments from within a LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal
        
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
        PS C:\> Get-LcsEnvironmentRsatCertificate -ProjectId 123456789 -Token "Bearer JldjfafLJdfjlfsalfd..." -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will get the raw rsat details for the environment from the LCS API.
        The ProjectId "123456789" is the desired project.
        The Token "Bearer JldjfafLJdfjlfsalfd..." is the authentication to be used.
        The EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" is the specific environment that we want the rsat certificate details from.
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-LcsEnvironmentRsatCertificate {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    # [CmdletBinding()]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
    
        [Alias('Token')]
        [Parameter(Mandatory = $true)]
        [string] $BearerToken,

        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,
        
        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    begin {
        Invoke-TimeSignal -Start
        
        $headers = @{
            "Authorization" = "$BearerToken"
        }

        $parms = @{}
        $parms.Method = "GET"
        $parms.Uri = "$LcsApiUri/environmentinfo/v1/rsatdownload/project/$($ProjectId)/environment/$EnvironmentId"
        $parms.Headers = $headers
        $parms.RetryTimeout = $RetryTimeout
    }

    process {
        try {
            Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
            Invoke-RequestHandler @parms
        }
        catch [System.Net.WebException] {
            Write-PSFMessage -Level Host -Message "Error status code <c='em'>$($_.exception.response.statuscode)</c> in request for getting the environment rsat certificate in LCS. <c='em'>$($_.exception.response.StatusDescription)</c>." -Exception $PSItem.Exception
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