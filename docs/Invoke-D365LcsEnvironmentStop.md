---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365LcsEnvironmentStop

## SYNOPSIS
Stop a specified environment through LCS.

## SYNTAX

```
Invoke-D365LcsEnvironmentStop [[-ProjectId] <Int32>] [[-BearerToken] <String>] [-EnvironmentId] <String>
 [[-LcsApiUri] <String>] [-EnableException]
 [<CommonParameters>]
```

## DESCRIPTION
Stop a specified IAAS environment that is Microsoft managed or customer managed through the LCS API

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365LcsEnvironmentStop -ProjectId 123456789 -EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will trigger the environment stop operation upon the given environment through the LCS APIs
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The environment is identified by the EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com"

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

## PARAMETERS

### -ProjectId
The project id for the Dynamics 365 for Finance & Operations project inside LCS

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:LcsApiProjectId
Accept pipeline input: False
Accept wildcard characters: False
```

### -BearerToken
The token you want to use when working against the LCS api

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases: Token

Required: False
Position: 2
Default value: $Script:LcsApiBearerToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnvironmentId
The unique id of the environment that you want to take the stop operation on.

The Id can be located inside the LCS portal

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

Depending where your LCS project is located, there are several valid URI's / URL's

Valid options:
"https://lcsapi.lcs.dynamics.com"
"https://lcsapi.eu.lcs.dynamics.com"
"https://lcsapi.fr.lcs.dynamics.com"
"https://lcsapi.sa.lcs.dynamics.com"
"https://lcsapi.uae.lcs.dynamics.com"
"https://lcsapi.lcs.dynamics.cn"

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:LcsApiLcsApiUri
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
Only IAAS (Customer managed and Microsoft managed) are supported with this API. Self-service environments do not have a stop functionality and will not work with this API.

Tags: Environment, Stop, LCS, Api

Author: Billy Richardson (@richardsondev)

## RELATED LINKS

[Invoke-D365LcsEnvironmentStart]()

[Get-D365LcsApiToken]()

[Invoke-D365LcsApiRefreshToken]()

[Get-D365LcsApiConfig]()

[Set-D365LcsApiConfig]()
