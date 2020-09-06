
<#
    .SYNOPSIS
        Get file from the Asset library inside the LCS project
        
    .DESCRIPTION
        Get the available files from the Asset Library in LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER FileType
        Type of file you want to upload
        
        Valid options:
        "Model"
        "Process Data Package"
        "Software Deployable Package"
        "GER Configuration"
        "Data Package"
        "PowerBI Report Model"
        "E-Commerce Package"
        "NuGet Package"
        "Retail Self-Service Package"
        "Commerce Cloud Scale Unit Extension"
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
    .EXAMPLE
        PS C:\> Get-LcsAssetFile -ProjectId 123456789 -FileType SoftwareDeployablePackage -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will get all software deployable packages from the Asset Library inside LCS.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The FileType is Software Deployable Packages, with the FileType parameter.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Tags: Environment, LCS, Api, AAD, Token, Asset, File, Files
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-LcsAssetFile {
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,

        [LcsAssetFileType] $FileType,

        [Alias('Token')]
        [string] $BearerToken,
        
        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri
    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Json payload for LCS generated." -Target $jsonFile
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("d365fo.tools via PowerShell")
    
    $fileTypeValue = [int]$FileType
    $lcsRequestUri = "$LcsApiUri/box/fileasset/GetAssets/$($ProjectId)?fileType=$($fileTypeValue)"
    
    $request = New-JsonRequest -Uri $lcsRequestUri -Token $BearerToken -HttpMethod "GET"

    try {
        Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
        $result = Get-AsyncResult -task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()

        try {
            $lcsResponseObject = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
        }
        catch {
            Write-PSFMessage -Level Critical -Message "$responseString"
        }

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS." -Target $lcsResponseObject
        
        if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
            if (($lcsResponseObject) -and ($lcsResponseObject.Message)) {
                $errorText = "Error $( $lcsResponseObject.Message) in request for listing all files from the asset library of LCS: '$( $lcsResponseObject.Message)'"
            }
            else {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase)"
            }

            Write-PSFMessage -Level Host -Message "Error listing bacpacs and backups from asset library." -Target $($lcsResponseObject.Message)
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }

    Invoke-TimeSignal -End
    
    $lcsResponseObject
}