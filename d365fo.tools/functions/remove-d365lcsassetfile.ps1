
<#
    .SYNOPSIS
        Delete asset from the LCS project Asset Library
        
    .DESCRIPTION
        Delete asset from the LCS project Asset Library
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER AssetId
        LCS Id of the file that you are looking for
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        Default value can be configured using Set-D365LcsApiConfig
        
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
        Default value can be configured using Set-D365LcsApiConfig
        
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
        PS C:\> Remove-D365LcsAssetFile -ProjectId 123456789 -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com" -AssetId "812bcb0e-23fb-476d-8a92-985f20a704b9"
        
        This will delete the Asset file from the LCS Asset Library.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Set-D365LcsApiConfig
        
    .LINK
        Remove-LcsAssetFile
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>
function Remove-D365LcsAssetFile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [int] $ProjectId = $Script:LcsApiProjectId,

        [Parameter(Mandatory = $true)]
        [string] $AssetId = "",
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }

    Remove-LcsAssetFile -BearerToken $BearerToken -ProjectId $ProjectId -LcsApiUri $LcsApiUri -RetryTimeout $RetryTimeout -AssetId $AssetId

    if (Test-PSFFunctionInterrupt) { return }

    Invoke-TimeSignal -End
}