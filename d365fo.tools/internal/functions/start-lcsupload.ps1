function Start-LcsUpload {
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [int]$ProjectId,

        [Parameter(Mandatory = $true)]
        [ValidateSet('DeployablePackage', 'DatabaseBackup')]
        [string]$FileType,

        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $false)]
        [string]$LcsApiUri
    )

    $fileName = Split-Path $FilePath -Leaf

    if ($Name -eq "") {
        $Name = $fileName
    }

    if ($Description -eq "") {
        $jsonDescription = "null"
    }
    else {
        $jsonDescription = "`"$Description`""
    }
    
    $fileTypeValue = 0

    switch ($FileType) {
        "DeployablePackage" { $fileTypeValue = 10 }
        "DatabaseBackup" { $fileTypeValue = 17 }
    }

    $jsonFile = "{ `"Name`": `"$Name`", `"FileName`": `"$fileName`", `"FileDescription`": $jsonDescription, `"SizeByte`": 0, `"FileType`": $fileTypeValue }"

    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()

    $createUri = "$LcsApiUri/box/fileasset/CreateFileAsset/$ProjectId"

    $request = New-JsonRequest -Uri $createUri -Content $jsonFile -Token $Token

    $result = Get-AsyncResult -task $client.SendAsync($request)

    $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()
    $asset = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
    
    if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
        if (($asset) -and ($asset.Message)) {
            #throw "Error creating new file asset: '$($asset.Message)'"
        }
        else {
            #throw "API Call returned $($result.StatusCode): $($result.ReasonPhrase)"
        }
    }

    if (-not ($asset.Id)) {
        if ($asset.Message) {
            # throw "Error creating new file asset: '$($asset.Message)'"
        }
        else {
            # throw "Unknown error creating new file asset"
        }
    }

    $asset
}