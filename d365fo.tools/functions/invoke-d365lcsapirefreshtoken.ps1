
<#
    .SYNOPSIS
        Refresh the token for lcs communication
        
    .DESCRIPTION
        Invoke the refresh logic that refreshes the token object based on the ClientId and RefreshToken
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER RefreshToken
        The Refresh Token that you want to use for the authentication process
        
    .PARAMETER InputObject
        The entire object that you received from the Get-D365LcsApiToken command, which contains the needed RefreshToken
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsApiRefreshToken -ClientId "dea8d7a9-1602-4429-b138-111111111111" -RefreshToken "Tsdljfasfe2j32324"
        
        This will use the ClientId "dea8d7a9-1602-4429-b138-111111111111" and RefreshToken "Tsdljfasfe2j32324" to obtain a new token object from Azure Active Directory
        
    .EXAMPLE
        PS C:\> $temp = Get-D365LcsApiToken -LcsApiUri "https://lcsapi.eu.lcs.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -Username "serviceaccount@domain.com" -Password "TopSecretPassword"
        PS C:\> $temp = Invoke-D365LcsApiRefreshToken -ClientId "dea8d7a9-1602-4429-b138-111111111111" -InputObject $temp
        
        This will obtain a new token object from the Get-D365LcsApiToken cmdlet and store it in $temp.
        Then it will pass $temp to the Invoke-D365LcsApiRefreshToken along with the ClientId "dea8d7a9-1602-4429-b138-111111111111".
        The new token object will be save into $temp.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiConfig | Invoke-D365LcsApiRefreshToken | Set-D365LcsApiConfig
        
        This will fetch the current LCS API details from Get-D365LcsApiConfig.
        Then it will pipe these information directly to Invoke-D365LcsApiRefreshToken, which will fetch a new token object.
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
        [PSCustomObject] $InputObject
    )

    if ($PsCmdlet.ParameterSetName -eq "Simple") {
        Invoke-RefreshToken -AuthProviderUri $Script:AADOAuthEndpoint @PSBoundParameters
    }
    else {
        Invoke-RefreshToken -AuthProviderUri $Script:AADOAuthEndpoint -ClientId $ClientId -RefreshToken $InputObject.refresh_token
    }
}