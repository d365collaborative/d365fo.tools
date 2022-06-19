
<#
    .SYNOPSIS
        Set the LCS configuration details
        
    .DESCRIPTION
        Set the LCS configuration details and save them into the configuration store
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER ClientId
        The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER ActiveTokenExpiresOn
        The point in time where the current bearer token will expire
        
        The time is measured in Unix Time, total seconds since 1970-01-01
        
    .PARAMETER RefreshToken
        The Refresh Token that you want to use for the authentication process
        
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
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily override the persisted settings in the configuration storage
        
    .EXAMPLE
        PS C:\> Set-D365LcsApiConfig -ProjectId 123456789 -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -BearerToken "JldjfafLJdfjlfsalfd..." -ActiveTokenExpiresOn 1556909205 -RefreshToken "Tsdljfasfe2j32324" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will set the LCS API configuration.
        The ProjectId 123456789 will be saved as the default ProjectId for all cmdlets that will interact with LCS, if they require a ProjectId.
        The ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" will be saved as the default ClientId for all cmdlets that will interact with LCS, if they require a ClientId.
        The BearerToken "JldjfafLJdfjlfsalfd..." will be saved as the default BearerToken. Remember the BearerToken will expire, so you should fill in the ActiveTokenExpiresOn and RefreshToken parameters also.
        The ActiveTokenExpiresOn 1556909205 will be saved to assist the module in determine whether the BearerToken is still valid or not.
        The RefreshToken "Tsdljfasfe2j32324" will be saved as the default RefreshToken for all cmdlets that will interact with tokens.
        The LcsApiUri "https://lcsapi.lcs.dynamics.com" will be saved as the default LCS HTTP endpoint for all cmdlets that will interact with LCS.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiToken -Username "serviceaccount@domain.com" -Password "TopSecretPassword" | Set-D365LcsApiConfig
        
        This will obtain a valid OAuth 2.0 access token from Azure Active Directory and save the needed details.
        The Username "serviceaccount@domain.com" and Password "TopSecretPassword" is used in the OAuth 2.0 Grant Flow, to approved that the application should impersonate like "serviceaccount@domain.com".
        The output object received from Get-D365LcsApiToken is piped directly to Set-D365LcsApiConfig.
        Set-D365LcsApiConfig will save the access_token(BearerToken), refresh_token(RefreshToken) and expires_on(ActiveTokenExpiresOn).
        
        These values will then be available as default values for all LCS cmdlets across the module.
        
        You can validate the current default values by calling Get-D365LcsApiConfig.
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Set-D365LcsApiConfig {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param(
        [int] $ProjectId,

        [string] $ClientId,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('access_token')]
        [Alias('AccessToken')]
        [string] $BearerToken,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('expires_on')]
        [long] $ActiveTokenExpiresOn,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('refresh_token')]
        [string] $RefreshToken,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('resource')]
        [string] $LcsApiUri = "https://lcsapi.lcs.dynamics.com",
        
        [switch] $Temporary


    )

    process {
        #The ':keys' label is used to have a continue inside the switch statement itself
        :keys foreach ($key in $PSBoundParameters.Keys) {
        
            $configurationValue = $PSBoundParameters.Item($key)
            $configurationName = $key.ToLower()
            $fullConfigName = ""

            Write-PSFMessage -Level Verbose -Message "Working on $key with $configurationValue" -Target $configurationValue
        
            switch ($key) {
                "Temporary" {
                    continue keys
                }

                Default {
                    $fullConfigName = "d365fo.tools.lcs.$configurationName"
                }
            }

            Write-PSFMessage -Level Verbose -Message "Setting $fullConfigName to $configurationValue" -Target $configurationValue
        
            Set-PSFConfig -FullName $fullConfigName -Value $configurationValue
            if (-not $Temporary) { Register-PSFConfig -FullName $fullConfigName -Scope UserDefault }
        }

        Update-LcsApiVariables
    }
}