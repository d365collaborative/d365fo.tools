
<#
    .SYNOPSIS
        Get the identity provider
        
    .DESCRIPTION
        Execute a web request to get the identity provider for the given email address
        
    .PARAMETER Email
        Email address on the account that you want to get the Identity Provider details about
        
    .EXAMPLE
        PS C:\> Get-IdentityProvider -Email "Claire@contoso.com"
        
        This will get the Identity Provider details for the user account with the email address "Claire@contoso.com"
        
    .NOTES
        Author : Rasmus Andersen (@ITRasmus)
        Author : Mötz Jensen (@splaxi)
        
#>
function Get-IdentityProvider {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Email
    )
    $tenant = Get-TenantFromEmail $Email

    try {
        $webRequest = New-WebRequest "https://login.windows.net/$tenant/.well-known/openid-configuration" $null "GET"

        $response = $WebRequest.GetResponse()

        if ($response.StatusCode -eq [System.Net.HttpStatusCode]::Ok) {

            $stream = $response.GetResponseStream()
    
            $streamReader = New-Object System.IO.StreamReader($stream);
        
            $openIdConfig = $streamReader.ReadToEnd()
            $streamReader.Close();
        }
        else {
            $statusDescription = $response.StatusDescription
            throw "Https status code : $statusDescription"
        }

        $openIdConfigJSON = ConvertFrom-Json $openIdConfig

        $openIdConfigJSON.issuer
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while executing the web request" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}