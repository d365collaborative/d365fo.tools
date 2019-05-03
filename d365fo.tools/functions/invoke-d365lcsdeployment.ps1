
<#
    .SYNOPSIS
        Start the deployment of a deployable package
        
    .DESCRIPTION
        Deploy a deployable package from the Asset Library from a LCS projcet using the API provided by Microsoft
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS

    .PARAMETER BearerToken
        The token you want to use when working against the LCS api

    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
    .EXAMPLE
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token, Deployment, Deploy
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365LcsDeployment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingUserNameAndPassWordParams", "")]
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Parameter(Mandatory = $false, Position = 2)]
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 5)]
        [string] $AssetId,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri
    )

    Invoke-TimeSignal -Start

    $tokenParms = @{}
    $tokenParms.Resource = $LcsApiUri
    $tokenParms.GrantType = $grantType
    $tokenParms.ClientId = $ClientId
    $tokenParms.Username = $Username
    $tokenParms.Password = $Password
    $tokenParms.Scope = "openid"
    $tokenParms.AuthProviderUri = "https://login.microsoftonline.com/common/oauth2/token"

    $bearerToken = Invoke-PasswordGrant @tokenParms
    
    $deploymentStatus = Start-LcsDeployment -Token $bearerToken -ProjectId $ProjectId -AssetId $AssetId

    if (Test-PSFFunctionInterrupt) { return }

    Invoke-TimeSignal -End

    [PSCustomObject]@{
        AssetId = $AssetId
    }
}