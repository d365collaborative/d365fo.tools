---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsApiToken

## SYNOPSIS
Get a valid OAuth 2.0 access token for LCS

## SYNTAX

```
Get-D365LcsApiToken [[-ClientId] <String>] [-Username] <String> [-Password] <String> [[-LcsApiUri] <String>]
 [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Get a valid OAuth 2.0 access token for LCS, by providing an easy way to work against the Azure AD of your tenant

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsApiToken -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username "serviceaccount@domain.com" -Password "TopSecretPassword" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will obtain a valid OAuth 2.0 access token from Azure Active Directory.
The ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" is used in the OAuth 2.0 Grant Flow to authenticate.
The Username "serviceaccount@domain.com" and Password "TopSecretPassword" is used in the OAuth 2.0 Grant Flow, to approved that the application should impersonate like "serviceaccount@domain.com".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

### EXAMPLE 2
```
Get-D365LcsApiToken -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username "serviceaccount@domain.com" -Password "TopSecretPassword" -LcsApiUri "https://lcsapi.lcs.dynamics.com" | Set-D365LcsApiConfig -ProjectId 123456789
```

This will obtain a valid OAuth 2.0 access token from Azure Active Directory.
The ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" is used in the OAuth 2.0 Grant Flow to authenticate.
The Username "serviceaccount@domain.com" and Password "TopSecretPassword" is used in the OAuth 2.0 Grant Flow, to approved that the application should impersonate like "serviceaccount@domain.com".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

The output object received from Get-D365LcsApiToken is piped directly to Set-D365LcsApiConfig.

Set-D365LcsApiConfig will save the ClientId, LcsApiUri, ProjectId, access_token(BearerToken), refresh_token(RefreshToken), expires_on(ActiveTokenExpiresOn) details for the module to use them across other LCS cmdlets.

This should be your default approach in using and leveraging the module, so you don't have to supply the same parameters for every single cmdlet.

### EXAMPLE 3
```
Get-D365LcsApiToken -Username "serviceaccount@domain.com" -Password "TopSecretPassword"
```

This will obtain a valid OAuth 2.0 access token from Azure Active Directory.
The Username "serviceaccount@domain.com" and Password "TopSecretPassword" is used in the OAuth 2.0 Grant Flow, to approved that the application should impersonate like "serviceaccount@domain.com".

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 4
```
Get-D365LcsApiToken -Username "serviceaccount@domain.com" -Password "TopSecretPassword" | Set-D365LcsApiConfig
```

This will obtain a valid OAuth 2.0 access token from Azure Active Directory and save the needed details.
The Username "serviceaccount@domain.com" and Password "TopSecretPassword" is used in the OAuth 2.0 Grant Flow, to approved that the application should impersonate like "serviceaccount@domain.com".
The output object received from Get-D365LcsApiToken is piped directly to Set-D365LcsApiConfig.
Set-D365LcsApiConfig will save the access_token(BearerToken), refresh_token(RefreshToken) and expires_on(ActiveTokenExpiresOn).

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

## PARAMETERS

### -ClientId
The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:LcsApiClientId
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The username of the account that you want to impersonate

It can either be your personal account or a service account

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password of the account that you want to impersonate

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LcsApiUri
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

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:LcsApiApiUri
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
Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsAssetValidationStatus]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsDeployment]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

