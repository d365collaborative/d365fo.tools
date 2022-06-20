---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365LcsDeployment

## SYNOPSIS
Start the deployment of a deployable package

## SYNTAX

### VM (Default)
```
Invoke-D365LcsDeployment [-ProjectId <Int32>] -AssetId <String> -EnvironmentId <String> [-BearerToken <String>]
 [-LcsApiUri <String>] [-FailOnErrorMessage] [-RetryTimeout <TimeSpan>] [-EnableException] [<CommonParameters>]
```

### Self-Service
```
Invoke-D365LcsDeployment [-ProjectId <Int32>] -AssetId <String> -EnvironmentId <String> -UpdateName <String>
 [-BearerToken <String>] [-LcsApiUri <String>] [-FailOnErrorMessage] [-RetryTimeout <TimeSpan>]
 [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Deploy a deployable package from the Asset Library from a LCS project using the API provided by Microsoft

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365LcsDeployment -ProjectId 123456789 -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -BearerToken "Bearer JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will start the deployment of the file located in the Asset Library.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

### EXAMPLE 2
```
Invoke-D365LcsDeployment -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
```

This will start the deployment of the file located in the Asset Library.
The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 3
```
Invoke-D365LcsDeployment -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -UpdateName "Release_XYZ"
```

This will start the deployment of the file located in the Asset Library against a Self-Service environment.
The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
The deployment is name "Release_XYZ" by setting the UpdateName parameter, which is mandatory when working against Self-Service environments.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 4
```
Invoke-D365LcsDeployment -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -RetryTimeout "00:01:00"
```

This will start the deployment of the file located in the Asset Library, and allow for the cmdlet to retry for no more than 1 minute.
The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.

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
Position: Named
Default value: $Script:LcsApiProjectId
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetId
The unique id of the asset / file that you are trying to deploy from LCS

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnvironmentId
The unique id of the environment that you want to work against

The Id can be located inside the LCS portal

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateName
Name of the update when you are working against Self-Service environments

```yaml
Type: String
Parameter Sets: Self-Service
Aliases:

Required: True
Position: Named
Default value: None
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
Position: Named
Default value: $Script:LcsApiBearerToken
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
Position: Named
Default value: $Script:LcsApiLcsApiUri
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailOnErrorMessage
Instruct the cmdlet to write logging information to the console, if there is an error message in the response from the LCS endpoint

Used in combination with either Enable-D365Exception cmdlet, or the -EnableException directly on this cmdlet, it will throw an exception and break/stop execution of the script
This allows you to implement custom retry / error handling logic

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

### -RetryTimeout
The retry timeout, before the cmdlet should quit retrying based on the 429 status code

Needs to be provided in the timspan notation:
"hh:mm:ss"

hh is the number of hours, numerical notation only
mm is the number of minutes
ss is the numbers of seconds

Each section of the timeout has to valid, e.g.
hh can maximum be 23
mm can maximum be 59
ss can maximum be 59

Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 00:00:00
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
Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token, Deployment, Deploy

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Get-D365LcsAssetValidationStatus]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

