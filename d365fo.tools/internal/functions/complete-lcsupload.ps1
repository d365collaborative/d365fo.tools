
<#
    .SYNOPSIS
        Complete the upload action in LCS
        
    .DESCRIPTION
        Signal to LCS that the upload of the blob has completed
        
    .PARAMETER Token
        The token to be used for the http request against the LCS API
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER AssetId
        The unique id of the asset / file that you are trying to upload to LCS
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
    .EXAMPLE
        PS C:\> Complete-LcsUpload -Token "Bearer JldjfafLJdfjlfsalfd..." -ProjectId 123456789 -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will commit the upload process for the AssetId "958ae597-f089-4811-abbd-c1190917eaae" in the LCS project with Id 123456789.
        The http request will be using the "Bearer JldjfafLJdfjlfsalfd..." token for authentication against the LCS API.
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Complete-LcsUpload {
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [int]$ProjectId,

        [Parameter(Mandatory = $true)]
        [string]$AssetId,

        [Parameter(Mandatory = $false)]
        [string]$LcsApiUri
    )
    
    Invoke-TimeSignal -Start

    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()

    $commitFileUri = "$LcsApiUri/box/fileasset/CommitFileAsset/$($ProjectId)?assetId=$AssetId"

    $request = New-JsonRequest -Uri $commitFileUri -Token $Token
    
    Write-PSFMessage -Level Verbose -Message "Sending the commit request against LCS" -Target $request

    try {
        $commitResult = Get-AsyncResult -Task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Parsing the commitResult for success" -Target $commitResult
        if (($commitResult.StatusCode -ne [System.Net.HttpStatusCode]::NoContent) -and ($commitResult.StatusCode -ne [System.Net.HttpStatusCode]::OK)) {
            Write-PSFMessage -Level Host -Message "The LCS API returned an http error code" -Exception $PSItem.Exception -Target $commitResult
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }

    Invoke-TimeSignal -End

    $commitResult
}