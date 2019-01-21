<#
.SYNOPSIS
Create a new Json HttpRequestMessage

.DESCRIPTION
Create a new HttpRequestMessage with the ContentType = application/json

.PARAMETER Uri
The URI / URL for the web site you want to work against

.PARAMETER Token
The token that contains the needed authorization permission

.PARAMETER Content
The content that you want to include in the HttpRequestMessage

.EXAMPLE
PS C:\> New-JsonRequest -Token "Bearer JldjfafLJdfjlfsalfd..." -Uri "https://lcsapi.lcs.dynamics.com/box/fileasset/CommitFileAsset/123456789?assetId=958ae597-f089-4811-abbd-c1190917eaae"

This will create a new HttpRequestMessage what will work against the "https://lcsapi.lcs.dynamics.com/box/fileasset/CommitFileAsset/123456789?assetId=958ae597-f089-4811-abbd-c1190917eaae".
It attaches the Token "Bearer JldjfafLJdfjlfsalfd..." to the request.

.NOTES
Tags: Json, Http, HttpRequestMessage, POST

Author: Mötz Jensen (@Splaxi)

#>

function New-JsonRequest {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Uri,
        
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Token,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]$Content
        
    )

    Write-PSFMessage -Level Verbose -Message "Building a HttpRequestMessage." -Target $Uri
    $request = New-Object -TypeName System.Net.Http.HttpRequestMessage -ArgumentList @([System.Net.Http.HttpMethod]::Post, $Uri)
    
    if (-not ($Content -eq "")) {
        Write-PSFMessage -Level Verbose -Message "Adding content to the HttpRequestMessage." -Target $Content
        $request.Content = New-Object -TypeName System.Net.Http.StringContent -ArgumentList @($Content, [System.Text.Encoding]::UTF8, "application/json")
    }

    Write-PSFMessage -Level Verbose -Message "Adding Authorization token to the HttpRequestMessage." -Target $Token
    $request.Headers.Authorization = $Token

    $request
}