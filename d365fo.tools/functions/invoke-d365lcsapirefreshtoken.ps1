
<#
    .SYNOPSIS
        Refresh the token for lcs communication
        
    .DESCRIPTION
        Invoke the refresh logic that refreshes the token object based on the ClientId and RefreshToken
        
    .PARAMETER ClientId
        The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal
        
    .PARAMETER RefreshToken
        The Refresh Token that you want to use for the authentication process
        
    .PARAMETER InputObject
        The entire object that you received from the Get-D365LcsApiToken command, which contains the needed RefreshToken
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsApiRefreshToken -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -RefreshToken "Tsdljfasfe2j32324"
        
        This will refresh an OAuth 2.0 access token, and obtain a (new) valid OAuth 2.0 access token from Azure Active Directory.
        The ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" is used in the OAuth 2.0 "Refresh Token" Grant Flow to authenticate.
        The RefreshToken "Tsdljfasfe2j32324" is used to prove to Azure Active Directoy that we are allowed to obtain a new valid Access Token.
        
    .EXAMPLE
        PS C:\> $temp = Get-D365LcsApiToken -LcsApiUri "https://lcsapi.eu.lcs.dynamics.com" -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username "serviceaccount@domain.com" -Password "TopSecretPassword"
        PS C:\> $temp = Invoke-D365LcsApiRefreshToken -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -InputObject $temp
        
        This will refresh an OAuth 2.0 access token, and obtain a (new) valid OAuth 2.0 access token from Azure Active Directory.
        This will obtain a new token object from the Get-D365LcsApiToken cmdlet and store it in $temp.
        Then it will pass $temp to the Invoke-D365LcsApiRefreshToken along with the ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929".
        The new token object will be save into $temp.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiConfig | Invoke-D365LcsApiRefreshToken | Set-D365LcsApiConfig
        
        This will refresh an OAuth 2.0 access token, and obtain a (new) valid OAuth 2.0 access token from Azure Active Directory.
        This will fetch the current LCS API details from Get-D365LcsApiConfig.
        The output from Get-D365LcsApiConfig is piped directly to Invoke-D365LcsApiRefreshToken, which will fetch a new token object.
        The new token object is piped directly into Set-D365LcsApiConfig, which will save the needed details into the configuration store.
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Get-D365LcsAssetValidationStatus
        
    .LINK
        Get-D365LcsDeploymentStatus
        
    .LINK
        Invoke-D365LcsDeployment
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Tags: LCS, API, Token, BearerToken
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365LcsApiRefreshToken {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseProcessBlockForPipelineCommand", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Simple")]
        [Parameter(Mandatory = $true, ParameterSetName = "Object")]
        [string] $ClientId,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Simple")]
        [Alias('refresh_token')]
        [Alias('Token')]
        [string] $RefreshToken,

        [Parameter(Mandatory = $false, ParameterSetName = "Object")]
        [PSCustomObject] $InputObject,

        [switch] $EnableException
    )

    if ($PsCmdlet.ParameterSetName -eq "Simple") {
        Invoke-RefreshToken -AuthProviderUri $Script:AADOAuthEndpoint @PSBoundParameters
    }
    else {
        Invoke-RefreshToken -AuthProviderUri $Script:AADOAuthEndpoint -ClientId $ClientId -RefreshToken $InputObject.refresh_token
    }
}