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
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()

    $commitFileUri = "$LcsApiUri/box/fileasset/CommitFileAsset/$($ProjectId)?assetId=$AssetId"

    $request = New-JsonRequest -Uri $commitFileUri -Token $Token
    
    $commitResult = Get-AsyncResult -Task $client.SendAsync($request)

    if (($commitResult.StatusCode -ne [System.Net.HttpStatusCode]::NoContent) -and ($commitResult.StatusCode -ne [System.Net.HttpStatusCode]::OK)) {
        #throw "API Call returned $($commitResult.StatusCode): $($commitResult.ReasonPhrase)"
    }

    $commitResult
}