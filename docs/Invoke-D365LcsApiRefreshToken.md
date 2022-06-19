---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365LcsApiRefreshToken

## SYNOPSIS
Refresh the token for lcs communication

## SYNTAX

### Object
```
Invoke-D365LcsApiRefreshToken -ClientId <String> [-InputObject <PSObject>] [-EnableException]
 [<CommonParameters>]
```

### Simple
```
Invoke-D365LcsApiRefreshToken -ClientId <String> -RefreshToken <String> [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Invoke the refresh logic that refreshes the token object based on the ClientId and RefreshToken

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365LcsApiRefreshToken -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -RefreshToken "Tsdljfasfe2j32324"
```

This will refresh an OAuth 2.0 access token, and obtain a (new) valid OAuth 2.0 access token from Azure Active Directory.
The ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" is used in the OAuth 2.0 "Refresh Token" Grant Flow to authenticate.
The RefreshToken "Tsdljfasfe2j32324" is used to prove to Azure Active Directoy that we are allowed to obtain a new valid Access Token.

### EXAMPLE 2
```
$temp = Get-D365LcsApiToken -LcsApiUri "https://lcsapi.eu.lcs.dynamics.com" -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username "serviceaccount@domain.com" -Password "TopSecretPassword"
```

PS C:\\\> $temp = Invoke-D365LcsApiRefreshToken -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -InputObject $temp

This will refresh an OAuth 2.0 access token, and obtain a (new) valid OAuth 2.0 access token from Azure Active Directory.
This will obtain a new token object from the Get-D365LcsApiToken cmdlet and store it in $temp.
Then it will pass $temp to the Invoke-D365LcsApiRefreshToken along with the ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929".
The new token object will be save into $temp.

### EXAMPLE 3
```
Get-D365LcsApiConfig | Invoke-D365LcsApiRefreshToken | Set-D365LcsApiConfig
```

This will refresh an OAuth 2.0 access token, and obtain a (new) valid OAuth 2.0 access token from Azure Active Directory.
This will fetch the current LCS API details from Get-D365LcsApiConfig.
The output from Get-D365LcsApiConfig is piped directly to Invoke-D365LcsApiRefreshToken, which will fetch a new token object.
The new token object is piped directly into Set-D365LcsApiConfig, which will save the needed details into the configuration store.

## PARAMETERS

### -ClientId
The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal

```yaml
Type: String
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Simple
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RefreshToken
The Refresh Token that you want to use for the authentication process

```yaml
Type: String
Parameter Sets: Simple
Aliases: Token, refresh_token

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InputObject
The entire object that you received from the Get-D365LcsApiToken command, which contains the needed RefreshToken

```yaml
Type: PSObject
Parameter Sets: Object
Aliases:

Required: False
Position: Named
Default value: None
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
Tags: LCS, API, Token, BearerToken

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Get-D365LcsAssetValidationStatus]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsDeployment]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

