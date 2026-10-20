---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsApiTokenInteractive

## SYNOPSIS
Get OAuth 2.0 token for LCS via an interactive sign-in flow

## SYNTAX

```
Get-D365LcsApiTokenInteractive [[-LcsApiUri] <String>] [[-Timeout] <Int32>] [-EnableException]
 [<CommonParameters>]
```

## DESCRIPTION
Get an OAuth 2.0 access token for the LCS API, using an interactive sign-in flow based on the device authentication flow

Your clipboard will be set with a device code, and your default browser will navigate to "https://microsoft.com/devicelogin"
You will have to paste in the device code, and complete an ordinary sign-in with your credentials
When your sign-in is complete, it will pick up the OAuth 2.0 token from Azure AD

The token is requested with the LcsApiUri as the resource / scope, to ensure it is valid against the correct LCS API endpoint

The output object can be piped directly into Set-D365LcsApiConfig to save the token details as default values

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsApiTokenInteractive
```

This will start an interactive sign-in process against Azure AD.
It will utilize the active LCS configuration for the LcsApiUri (Resource).
It will copy the device code into your clipboard.
It will start the default browser and navigate to "https://microsoft.com/devicelogin".
It will wait the default amount of seconds for you to complete the interactive sign-in.

It will use the default LCS configuration details that are stored in the configuration store.

### EXAMPLE 2
```
Get-D365LcsApiTokenInteractive -LcsApiUri "https://lcsapi.eu.lcs.dynamics.com"
```

This will start an interactive sign-in process against Azure AD.
It will request a token with the "https://lcsapi.eu.lcs.dynamics.com" LCS API as the resource / scope.
It will copy the device code into your clipboard.
It will start the default browser and navigate to "https://microsoft.com/devicelogin".
It will wait the default amount of seconds for you to complete the interactive sign-in.

### EXAMPLE 3
```
Get-D365LcsApiTokenInteractive | Set-D365LcsApiConfig -ProjectId 123456789
```

This will start an interactive sign-in process against Azure AD and save the needed details.
The output object received from Get-D365LcsApiTokenInteractive is piped directly to Set-D365LcsApiConfig.
Set-D365LcsApiConfig will save the access_token(BearerToken), refresh_token(RefreshToken), expires_on(ActiveTokenExpiresOn) and resource(LcsApiUri).

This should be your default approach, so you don't have to supply the same parameters for every single cmdlet.

### EXAMPLE 4
```
Get-D365LcsApiTokenInteractive -LcsApiUri "https://lcsapi.lcs.dynamics.com" | Set-D365LcsApiConfig
```

This will start an interactive sign-in process against Azure AD and save the needed details.
It will request a token with the "https://lcsapi.lcs.dynamics.com" (NON-EUROPE) LCS API as the resource / scope.
The output object received from Get-D365LcsApiTokenInteractive is piped directly to Set-D365LcsApiConfig.
Set-D365LcsApiConfig will save the access_token(BearerToken), refresh_token(RefreshToken), expires_on(ActiveTokenExpiresOn) and resource(LcsApiUri).

## PARAMETERS

### -LcsApiUri
URI / URL to the LCS API you want to use

The value depends on where your LCS project is located.
There are multiple valid URI's / URL's

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

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:LcsApiLcsApiUri
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Instruct the cmdlet how long time you need to be able to complete the interactive logon

The default value is: 300 seconds

Note: The parameter doesn't show up in the intellisense when tabbing through all available parameters, as it shouldn't be necessary to change the value

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: LCS, Api, OAuth, Token, JWT, DeviceAuth, Device, DeviceCode

Inspiration: https://blog.simonw.se/getting-an-access-token-for-azuread-using-powershell-and-device-login-flow/

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Set-D365LcsApiConfig]()

[Invoke-D365LcsApiRefreshToken]()

