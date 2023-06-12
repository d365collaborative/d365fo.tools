
<#
    .SYNOPSIS
        Get a valid OAuth 2.0 access token for LCS
        
    .DESCRIPTION
        Get a valid OAuth 2.0 access token for LCS, by providing an easy way to work against the Azure AD of your tenant
        
    .PARAMETER ClientId
        The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER Username
        The username of the account that you want to impersonate
        
        It can either be your personal account or a service account
        
    .PARAMETER Password
        The password of the account that you want to impersonate
        
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
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiToken -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username "serviceaccount@domain.com" -Password "TopSecretPassword" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will obtain a valid OAuth 2.0 access token from Azure Active Directory.
        The ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" is used in the OAuth 2.0 Grant Flow to authenticate.
        The Username "serviceaccount@domain.com" and Password "TopSecretPassword" is used in the OAuth 2.0 Grant Flow, to approved that the application should impersonate like "serviceaccount@domain.com".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiToken -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username "serviceaccount@domain.com" -Password "TopSecretPassword" -LcsApiUri "https://lcsapi.lcs.dynamics.com" | Set-D365LcsApiConfig -ProjectId 123456789
        
        This will obtain a valid OAuth 2.0 access token from Azure Active Directory.
        The ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" is used in the OAuth 2.0 Grant Flow to authenticate.
        The Username "serviceaccount@domain.com" and Password "TopSecretPassword" is used in the OAuth 2.0 Grant Flow, to approved that the application should impersonate like "serviceaccount@domain.com".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
        The output object received from Get-D365LcsApiToken is piped directly to Set-D365LcsApiConfig.
        
        Set-D365LcsApiConfig will save the ClientId, LcsApiUri, ProjectId, access_token(BearerToken), refresh_token(RefreshToken), expires_on(ActiveTokenExpiresOn) details for the module to use them across other LCS cmdlets.
        
        This should be your default approach in using and leveraging the module, so you don't have to supply the same parameters for every single cmdlet.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiToken -Username "serviceaccount@domain.com" -Password "TopSecretPassword"
        
        This will obtain a valid OAuth 2.0 access token from Azure Active Directory.
        The Username "serviceaccount@domain.com" and Password "TopSecretPassword" is used in the OAuth 2.0 Grant Flow, to approved that the application should impersonate like "serviceaccount@domain.com".
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiToken -Username "serviceaccount@domain.com" -Password "TopSecretPassword" | Set-D365LcsApiConfig
        
        This will obtain a valid OAuth 2.0 access token from Azure Active Directory and save the needed details.
        The Username "serviceaccount@domain.com" and Password "TopSecretPassword" is used in the OAuth 2.0 Grant Flow, to approved that the application should impersonate like "serviceaccount@domain.com".
        The output object received from Get-D365LcsApiToken is piped directly to Set-D365LcsApiConfig.
        Set-D365LcsApiConfig will save the access_token(BearerToken), refresh_token(RefreshToken) and expires_on(ActiveTokenExpiresOn).
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsAssetValidationStatus
        
    .LINK
        Get-D365LcsDeploymentStatus
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Invoke-D365LcsDeployment
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365LcsApiToken {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingUserNameAndPassWordParams", "")]
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $ClientId = $Script:LcsApiClientId,

        [Parameter(Mandatory = $true)]
        [string] $Username,

        [Parameter(Mandatory = $true)]
        [string] $Password,

        [Parameter(Mandatory = $false)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    $tokenParms = @{ }
    $tokenParms.Resource = $LcsApiUri
    $tokenParms.ClientId = $ClientId
    $tokenParms.Username = $Username
    $tokenParms.Password = $Password
    $tokenParms.Scope = "openid"
    $tokenParms.AuthProviderUri = $Script:AADOAuthEndpoint

    Invoke-PasswordGrant @tokenParms

    Invoke-TimeSignal -End
}