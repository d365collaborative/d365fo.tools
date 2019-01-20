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

    $Authorization = Invoke-RestMethod https://login.microsoftonline.com/common/oauth2/token `
        -Method Post -ContentType "application/x-www-form-urlencoded" `
        -Body $body `
        -ErrorAction STOP

    $Authorization.access_token
}
