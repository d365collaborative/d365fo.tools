
<#
    .SYNOPSIS
        Create a new authorization header
        
    .DESCRIPTION
        Get a new authorization header by acquiring a token from the authority web service
        
    .PARAMETER Authority
        The authority that you want to work against
        
    .PARAMETER ClientId
        The client id that you have registered for getting access to the web resource that you want to work against
        
    .PARAMETER ClientSecret
        The client secret that enables you to prove that you have privileges to get an authorization header
        
    .PARAMETER D365FO
        The URL to the Dynamics 365 for Finance & Operations that you want to work against
        
    .EXAMPLE
        PS C:\> New-AuthorizationHeader -Authority "XYZ" -ClientId "123" -ClientSecret "TopSecretId" -D365FO "https://usnconeboxax1aos.cloud.onebox.dynamics.com"
        
        This will retrieve a new authorization header from the D365FO instance located at "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function New-AuthorizationHeader {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    Param (
        [string] $Authority,
        [string] $ClientId,
        [string] $ClientSecret,
        [string] $D365FO
    )
    
    $authContext = new-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext ($Authority, $false)

    $clientCred = New-Object  Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential($ClientId, $ClientSecret)

    $task = $authContext.AcquireTokenAsync($D365FO, $clientCred)

    $taskStatus = $task.Wait(1000)

    Write-PSFMessage -Level Verbose -Message "Status $TaskStatus"

    $authorizationHeader = $task.Result

    Write-PSFMessage -Level Verbose -Message "AuthorizationHeader $authorizationHeader"

    $authorizationHeader
}