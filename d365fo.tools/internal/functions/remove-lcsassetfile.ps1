
<#
    .SYNOPSIS
        Delete a single asset from the LCS project Asset Library
        
    .DESCRIPTION
        Delete a single asset from the LCS project Asset Library
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER AssetId
        Id of the asset you want to delete
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
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
        Usually this parameter is not used directly, but via the Enable-D365Exception cmdlet
        See https://github.com/d365collaborative/d365fo.tools/wiki/Exception-handling#what-does-the--enableexception-parameter-do for further information
        
    .EXAMPLE
        Remove-LcsAssetFile -ProjectId 123456789 -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com" -AssetId "812bcb0e-23fb-476d-8a92-985f20a704b9"
        
        This will delete the Asset file from the LCS Asset Library.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Tags: Environment, LCS, Api, AAD, Token, Asset, File, Files
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Remove-LcsAssetFile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,

        [Parameter(Mandatory = $true)]
        [string] $AssetId,

        [Alias('Token')]
        [string] $BearerToken,
        
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
        $parms.Method = "POST"
        $parms.Uri = "$LcsApiUri/box/fileasset/DeleteFileAsset/$($ProjectId)?assetId=$($AssetId)"
        $parms.Headers = $headers
        $parms.RetryTimeout = $RetryTimeout
    }
    process {
        try {
            Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
            Invoke-RequestHandler @parms
            Write-PSFMessage -Level Verbose -Message "Asset was deleted successfully."
        }
        catch [System.Net.WebException] {
            Write-PSFMessage -Level Host -Message "Error status code <c='em'>$($_.exception.response.statuscode)</c> in request for delete asset from the asset library of LCS. <c='em'>$($_.exception.response.StatusDescription)</c>." -Exception $PSItem.Exception
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