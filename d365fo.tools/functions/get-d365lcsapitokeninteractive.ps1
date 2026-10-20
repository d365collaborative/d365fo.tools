<#
    .SYNOPSIS
        Get OAuth 2.0 token for LCS via an interactive sign-in flow
        
    .DESCRIPTION
        Get an OAuth 2.0 access token for the LCS API, using an interactive sign-in flow based on the device authentication flow
        
        Your clipboard will be set with a device code, and your default browser will navigate to "https://microsoft.com/devicelogin"
        You will have to paste in the device code, and complete an ordinary sign-in with your credentials
        When your sign-in is complete, it will pick up the OAuth 2.0 token from Azure AD
        
        The token is requested with the LcsApiUri as the resource / scope, to ensure it is valid against the correct LCS API endpoint
        
        The output object can be piped directly into Set-D365LcsApiConfig to save the token details as default values
        
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
        
    .PARAMETER Timeout
        Instruct the cmdlet how long time you need to be able to complete the interactive logon
        
        The default value is: 300 seconds
        
        Note: The parameter doesn't show up in the intellisense when tabbing through all available parameters, as it shouldn't be necessary to change the value
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiTokenInteractive
        
        This will start an interactive sign-in process against Azure AD.
        It will utilize the active LCS configuration for the LcsApiUri (Resource).
        It will copy the device code into your clipboard.
        It will start the default browser and navigate to "https://microsoft.com/devicelogin".
        It will wait the default amount of seconds for you to complete the interactive sign-in.
        
        It will use the default LCS configuration details that are stored in the configuration store.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiTokenInteractive -LcsApiUri "https://lcsapi.eu.lcs.dynamics.com"
        
        This will start an interactive sign-in process against Azure AD.
        It will request a token with the "https://lcsapi.eu.lcs.dynamics.com" LCS API as the resource / scope.
        It will copy the device code into your clipboard.
        It will start the default browser and navigate to "https://microsoft.com/devicelogin".
        It will wait the default amount of seconds for you to complete the interactive sign-in.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiTokenInteractive | Set-D365LcsApiConfig -ProjectId 123456789
        
        This will start an interactive sign-in process against Azure AD and save the needed details.
        The output object received from Get-D365LcsApiTokenInteractive is piped directly to Set-D365LcsApiConfig.
        Set-D365LcsApiConfig will save the access_token(BearerToken), refresh_token(RefreshToken), expires_on(ActiveTokenExpiresOn) and resource(LcsApiUri).
        
        This should be your default approach, so you don't have to supply the same parameters for every single cmdlet.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiTokenInteractive -LcsApiUri "https://lcsapi.lcs.dynamics.com" | Set-D365LcsApiConfig
        
        This will start an interactive sign-in process against Azure AD and save the needed details.
        It will request a token with the "https://lcsapi.lcs.dynamics.com" (NON-EUROPE) LCS API as the resource / scope.
        The output object received from Get-D365LcsApiTokenInteractive is piped directly to Set-D365LcsApiConfig.
        Set-D365LcsApiConfig will save the access_token(BearerToken), refresh_token(RefreshToken), expires_on(ActiveTokenExpiresOn) and resource(LcsApiUri).
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Set-D365LcsApiConfig
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .NOTES
        Tags: LCS, Api, OAuth, Token, JWT, DeviceAuth, Device, DeviceCode
        
        Inspiration: https://blog.simonw.se/getting-an-access-token-for-azuread-using-powershell-and-device-login-flow/
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365LcsApiTokenInteractive {
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [Parameter(DontShow = $true)]
        [int] $Timeout = 300,

        [switch] $EnableException
    )

    begin {
        Invoke-TimeSignal -Start

        if ([System.String]::IsNullOrEmpty($LcsApiUri)) {
            $messageString = "It seems that you didn't supply a valid value for the LcsApiUri parameter. You need to specify the LcsApiUri parameter or add a configuration with the <c='em'>Set-D365LcsApiConfig</c> cmdlet."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }

        if ($LcsApiUri.Substring($LcsApiUri.Length - 1) -eq "/") {
            Write-PSFMessage -Level Verbose -Message "The LcsApiUri parameter had a trailing slash, which shouldn't be there. Removing the trailing slash." -Target $LcsApiUri
            $LcsApiUri = $LcsApiUri.Substring(0, $LcsApiUri.Length - 1)
        }

        # Known ClientId for PowerShell in Azure AD
        $clientId = '1950a258-227b-4e31-a9cf-717495945fc2'
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        $azureUriToken = $Script:AADOAuthEndpoint
        if ([System.String]::IsNullOrEmpty($azureUriToken)) {
            $azureUriToken = "https://login.microsoftonline.com/common/oauth2/token"
        }

        $azureUriDeviceCode = $azureUriToken -replace "/token$", "/devicecode"

        $DeviceCodeRequestParams = @{
            Method = 'POST'
            Uri    = $azureUriDeviceCode
            Body   = @{
                resource  = $LcsApiUri
                client_id = $clientId
            }
        }

        $DeviceCodeRequest = Invoke-RestMethod @DeviceCodeRequestParams

        $DeviceCodeRequest.user_code | Set-Clipboard
        Write-PSFMessage -Level Host -Message "The device code <c='em'>$($DeviceCodeRequest.user_code)</c> has been copied into your clipboard."
        Start-Sleep -Seconds 2
        Write-PSFMessage -Level Host -Message "Will start the default browser and have it open the <c='em'>$($DeviceCodeRequest.verification_url)</c> page, where you need to <c='em'>paste</c> the code in and complete sign-in with your credentials."
        Start-Sleep -Seconds 2
        Start-Process $DeviceCodeRequest.verification_url

        $TokenRequestParams = @{
            Method = 'POST'
            Uri    = $azureUriToken
            Body   = @{
                grant_type = "urn:ietf:params:oauth:grant-type:device_code"
                code       = $DeviceCodeRequest.device_code
                client_id  = $clientId
            }
        }

        $TimeoutTimer = [System.Diagnostics.Stopwatch]::StartNew()
        $tokenObj = $null
        while ([string]::IsNullOrEmpty($tokenObj.access_token)) {
            if (Test-PSFFunctionInterrupt) { return }

            if ($TimeoutTimer.Elapsed.TotalSeconds -gt $Timeout) {
                $messageString = "The login session <c='em'>timed out</c>. You have <c='em'>$Timeout seconds</c> to complete the sign-in operation."
                Write-PSFMessage -Level Host -Message $messageString
                Stop-PSFFunction -Message "Stopping because login took too long." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
                return
            }
            $tokenObj = try {
                Invoke-RestMethod @TokenRequestParams -ErrorAction Stop
            }
            catch {
                $Message = $_.ErrorDetails.Message | ConvertFrom-Json
                if ($Message.error -ne "authorization_pending") {
                    throw
                }
            }
            Start-Sleep -Seconds 1
        }

        if ($null -ne $tokenObj -and -not ($tokenObj.PSObject.Properties.Name -contains "resource")) {
            Add-Member -InputObject $tokenObj -MemberType NoteProperty -Name "resource" -Value $LcsApiUri -Force
        }

        $tokenObj
    }

    end {
        Invoke-TimeSignal -End
    }
}
