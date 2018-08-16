function Get-IdentityProvider {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Email
    )


    $tenant = Get-TenantFromEmail $Email

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


    $openIdConfigJSON = convertfrom-json $openIdConfig

    $openIdConfigJSON.issuer

}