function New-AuthorizationHeader($Authority, $ClientId, $ClientSecret, $D365FO )
{
    
    $authContext = new-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext ($Authority,$false)

    $clientCred = New-Object  Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential($ClientId, $ClientSecret)

    $task = $authContext.AcquireTokenAsync($D365FO, $clientCred)

    $taskStatus = $task.Wait(1000)

    Write-PSFMessage -Level Verbose -Message "Status $TaskStatus"

    $authorizationHeader = $task.Result

    Write-PSFMessage -Level Verbose -Message "AuthorizationHeader $authorizationHeader"

    $authorizationHeader


}