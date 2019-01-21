
<#
    .SYNOPSIS
        Authenticate against Azure Active Directory (AAD)
        
    .DESCRIPTION
        Authenticate against Azure Active Directory (AAD) and retrieve a token
        
    .PARAMETER Resource
        The resource / URL you want the authentication to be valid for
        
    .PARAMETER GrantType
        The type of grant you want the authentication request to be
        
        Valid options (non-validated):
        authorization_code
        refresh_token
        password
        client_credentials
        
    .PARAMETER ClientId
        The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal
        
    .PARAMETER ClientSecret
        The secret obtained when you created a secret in relation to the Registered Application from the Azure Portal
        
    .PARAMETER Username
        The username of the account that you want to impersonate
        
    .PARAMETER Password
        The password of the account that you want to impersonate
        
    .PARAMETER Scope
        The scope value to apply to the authentication request
        
    .PARAMETER AuthProviderUri
        The URI / URL for the Authentication Provider you want to authenticate against
        
        Default value is "https://login.microsoftonline.com/common/oauth2"
        
    .EXAMPLE
        PS C:\> Invoke-AadAuthentication -Resource "https://lcsapi.lcs.dynamics.com" -GrantType "password" -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username claire@contoso.com -Password "pass@word1" -Scope openid
        
        This will create a http authentication request against the default AuthProviderUri ("https://login.microsoftonline.com/common/oauth2").
        The request will be for the Resource "https://lcsapi.lcs.dynamics.com".
        The GrantType will be "password".
        The ClientId will "9b4f4503-b970-4ade-abc6-2c086e4c4929".
        The Username is claire@contoso.com, and the Password is "pass@word1".
        The Scope is "openid"
        
    .NOTES
        Tags: Authentication, AAD, Azure Active Directory, Grant, ClientId
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-AadAuthentication {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingUserNameAndPassWordParams", "")]
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $Resource,

        [Parameter(Mandatory = $true, Position = 2)]
        [string] $GrantType,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $ClientId,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $ClientSecret,

        [Parameter(Mandatory = $false, Position = 5)]
        [string] $Username,

        [Parameter(Mandatory = $false, Position = 6)]
        [string] $Password,

        [Parameter(Mandatory = $false, Position = 7)]
        [string] $Scope,

        [Parameter(Mandatory = $false, Position = 8)]
        [string]$AuthProviderUri = "https://login.microsoftonline.com/common/oauth2"
    )

    Invoke-TimeSignal -Start

    $parms = @{}
    $parms.resource = [System.Web.HttpUtility]::UrlEncode($Resource)
    $parms.grant_type = [System.Web.HttpUtility]::UrlEncode($GrantType)
    
    if (-not ($ClientId -eq "")) {$parms.client_id = [System.Web.HttpUtility]::UrlEncode($ClientId)}

    if (-not ($ClientSecret -eq "")) {$parms.client_secret = [System.Web.HttpUtility]::UrlEncode($ClientSecret)}

    if (-not ($Username -eq "")) {$parms.username = [System.Web.HttpUtility]::UrlEncode($Username)}

    if (-not ($Password -eq "")) {$parms.password = [System.Web.HttpUtility]::UrlEncode($Password)}

    if (-not ($Scope -eq "")) {$parms.scope = [System.Web.HttpUtility]::UrlEncode($Scope)}

    $body = (Convert-HashToArgStringSwitch -InputObject $parms -KeyPrefix "&" -ValuePrefix "=") -join ""

    $body = $body.Substring(1)

    Write-PSFMessage -Level Verbose -Message "Authenticating against Azure Active Directory (AAD)." -Target $body

    try {
        $requestParams = @{Method = "Post"; ContentType = "application/x-www-form-urlencoded";
                    Body = $body}

        $Authorization = Invoke-RestMethod https://login.microsoftonline.com/common/oauth2/token @requestParams
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against Azure Active Directory (AAD)" -Exception $PSItem.Exception -Target $body
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }

    $Authorization.access_token
}