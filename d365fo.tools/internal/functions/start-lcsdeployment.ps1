
<#
    .SYNOPSIS
        Start LCS deployment
        
    .DESCRIPTION
        Start the deployment of a deployable package from the LCS API
        
    .PARAMETER Token
        The token to be used for the http request against the LCS API
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER AssetId
        The unique id of the asset / file that you are trying to upload to LCS
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
    .EXAMPLE
        PS C:\> Start-LcsDeployment  -Token "Bearer JldjfafLJdfjlfsalfd..." -ProjectId 123456789 -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the deployment of the file located in the Asset Library with the AssetId "958ae597-f089-4811-abbd-c1190917eaae" in the LCS project with Id 123456789.
        The http request will be using the "Bearer JldjfafLJdfjlfsalfd..." token for authentication against the LCS API.
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token, Deployment, Deployable Package
        
        Author: Mötz Jensen (@Splaxi)
#>

function Start-LcsDeployment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Token,

        [Parameter(Mandatory = $true)]
        [int] $ProjectId,

        [Parameter(Mandatory = $false)]
        [string] $AssetId,

        [Parameter(Mandatory = $false)]
        [string] $LcsApiUri
    )

    Invoke-TimeSignal -Start

    if ($Description -eq "") {
        $jsonDescription = "null"
    }
    else {
        $jsonDescription = "`"$Description`""
    }
    
    $fileTypeValue = 0

    switch ($FileType) {
        "Model" { $fileTypeValue = 1 }
        "Process Data Package" { $fileTypeValue = 4 }
        "Software Deployable Package" { $fileTypeValue = 10 }
        "GER Configuration" { $fileTypeValue = 12 }
        "Data Package" { $fileTypeValue = 15 }
        "PowerBI Report Model" { $fileTypeValue = 19 }
    }

    $jsonFile = "{ `"Name`": `"$Name`", `"FileName`": `"$fileName`", `"FileDescription`": $jsonDescription, `"SizeByte`": 0, `"FileType`": $fileTypeValue }"

    Write-PSFMessage -Level Verbose -Message "Json payload for LCS generated." -Target $jsonFile
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()

    $createUri = "$LcsApiUri/box/fileasset/CreateFileAsset/$ProjectId"

    $request = New-JsonRequest -Uri $createUri -Content $jsonFile -Token $Token

    try {
        Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
        $result = Get-AsyncResult -task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()

        $asset = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
    
        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
            if (($asset) -and ($asset.Message)) {
                Write-PSFMessage -Level Host -Message "Error creating new file asset." -Target $($asset.Message)
                Stop-PSFFunction -Message "Stopping because of errors"
            }
            else {
                Write-PSFMessage -Level Host -Message "API Call returned $($result.StatusCode)." -Target $($result.ReasonPhrase)
                Stop-PSFFunction -Message "Stopping because of errors"
            }
        }

        if (-not ($asset.Id)) {
            if ($asset.Message) {
                Write-PSFMessage -Level Host -Message "Error creating new file asset." -Target $($asset.Message)
                Stop-PSFFunction -Message "Stopping because of errors"
            }
            else {
                Write-PSFMessage -Level Host -Message "Unknown error creating new file asset." -Target $asset
                Stop-PSFFunction -Message "Stopping because of errors"
            }
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    Invoke-TimeSignal -End
    
    $asset
}