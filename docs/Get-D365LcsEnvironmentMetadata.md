---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsEnvironmentMetadata

## SYNOPSIS
Get LCS environment meta data from within a project

## SYNTAX

### Default (Default)
```
Get-D365LcsEnvironmentMetadata [-ProjectId <Int32>] [-BearerToken <String>] [-LcsApiUri <String>]
 [-FailOnErrorMessage] [-RetryTimeout <TimeSpan>] [-EnableException] [<CommonParameters>]
```

### SearchByEnvironmentId
```
Get-D365LcsEnvironmentMetadata [-ProjectId <Int32>] [-BearerToken <String>] [-EnvironmentId <String>]
 [-LcsApiUri <String>] [-FailOnErrorMessage] [-RetryTimeout <TimeSpan>] [-EnableException] [<CommonParameters>]
```

### SearchByEnvironmentName
```
Get-D365LcsEnvironmentMetadata [-ProjectId <Int32>] [-BearerToken <String>] [-EnvironmentName <String>]
 [-LcsApiUri <String>] [-FailOnErrorMessage] [-RetryTimeout <TimeSpan>] [-EnableException] [<CommonParameters>]
```

### Pagination
```
Get-D365LcsEnvironmentMetadata [-ProjectId <Int32>] [-BearerToken <String>] [-TraverseAllPages]
 [-FirstPages <Int32>] [-LcsApiUri <String>] [-FailOnErrorMessage] [-RetryTimeout <TimeSpan>]
 [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Get all meta data details for environments from within a LCS project

It supports listing all environments, but also supports single / specific environments by searching based on EnvironmentId or EnvironmentName

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsEnvironmentMetadata -ProjectId "123456789"
```

This will show metadata for every available environment from the LCS project.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.

The request time for completion is directly impacted by the number of environments within the LCS project.
Please be patient and let the system work for you.

You might experience that not all environments are listed with this request, that would indicate that the LCS project has many environments.
Please use the -TraverseAllPages parameter to ensure that all environments are outputted.

A result set example (Tier1):

EnvironmentId                  : c6566087-23bd-4561-8247-4d7f4efd3172
EnvironmentName                : DevBox-01
ProjectId                      : 123456789
EnvironmentInfrastructure      : CustomerManaged
EnvironmentType                : DevTestDev
EnvironmentGroup               : Primary
EnvironmentProduct             : Finance and Operations
EnvironmentEndpointBaseUrl     : https://devbox-4d7f4efd3172devaos.cloudax.dynamics.com/
DeploymentState                : Stopped
TopologyDisplayName            : Finance and Operations - Develop (10.0.18 with Platform update 42)
CurrentApplicationBuildVersion : 10.0.793.41
CurrentApplicationReleaseName  : 10.0.18
CurrentPlatformReleaseName     : Update42
CurrentPlatformVersion         : 7.0.5968.16999
DeployedOnUTC                  : 7/5/2021 11:19 AM
CloudStorageLocation           : West Europe
DisasterRecoveryLocation       : North Europe
DeploymentStatusDisplay        : Stopped
CanStart                       : True
CanStop                        : False

A result set example (Tier2+):

EnvironmentId                  : e7c53b85-8b6a-4ab9-8985-1e1ea89a0f0a
EnvironmentName                : Contoso-SIT
ProjectId                      : 123456789
EnvironmentInfrastructure      : SelfService
EnvironmentType                : Sandbox
EnvironmentGroup               : Primary
EnvironmentProduct             : Finance and Operations
EnvironmentEndpointBaseUrl     : https://Contoso-SIT.sandbox.operations.dynamics.com/
DeploymentState                : Finished
TopologyDisplayName            : AXHA
CurrentApplicationBuildVersion : 10.0.761.10019
CurrentApplicationReleaseName  : 10.0.17
CurrentPlatformReleaseName     : PU41
CurrentPlatformVersion         : 7.0.5934.35741
DeployedOnUTC                  : 4/1/2020 9:35 PM
CloudStorageLocation           : West Europe
DisasterRecoveryLocation       :
DeploymentStatusDisplay        : Deployed
CanStart                       : False
CanStop                        : False

A result set example (PROD):

EnvironmentId                  : a8aab4f4-d4f3-41f0-af80-54cea83b50d2
EnvironmentName                : Contoso-PROD
ProjectId                      : 123456789
EnvironmentInfrastructure      : SelfService
EnvironmentType                : Production
EnvironmentGroup               : Primary
EnvironmentProduct             : Finance and Operations
EnvironmentEndpointBaseUrl     : https://Contoso-PROD.operations.dynamics.com/
DeploymentState                : Finished
TopologyDisplayName            : AXHA
CurrentApplicationBuildVersion : 10.0.886.48
CurrentApplicationReleaseName  : 10.0.20
CurrentPlatformReleaseName     : PU44
CurrentPlatformVersion         : 7.0.6060.45
DeployedOnUTC                  : 4/9/2020 12:11 PM
CloudStorageLocation           : West Europe
DisasterRecoveryLocation       :
DeploymentStatusDisplay        : Deployed
CanStart                       : False
CanStop                        : False

### EXAMPLE 2
```
Get-D365LcsEnvironmentMetadata -ProjectId "123456789" -TraverseAllPages
```

This will show metadata for every available environment from the LCS project, across multiple pages.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
It will use the default value for the maximum number of pages to return, 99 pages.

TraverseAllPages will increase the request time for completion, based on how many entries there is in the history.
Please be patient and let the system work for you.

Please note that when fetching more than 6-7 pages, you will start hitting the 429 throttling from the LCS API endpoint

### EXAMPLE 3
```
Get-D365LcsEnvironmentMetadata -ProjectId "123456789" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
```

This will show metadata for every available environment from the LCS project.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.

### EXAMPLE 4
```
Get-D365LcsEnvironmentMetadata -ProjectId "123456789" -EnvironmentName "Contoso-SIT"
```

This will show metadata for every available environment from the LCS project.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The environment is identified by the EnvironmentName "Contoso-SIT", which can be obtained in the LCS portal.

### EXAMPLE 5
```
Get-D365LcsEnvironmentMetadata -ProjectId "123456789" -TraverseAllPages -FirstPages 2
```

This will show metadata for every available environment from the LCS project, across multiple pages.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
It will use the default value for the maximum number of pages to return, 99 pages.
The cmdlet will be fetching the FirstPages 2, to limit the output from the cmdlet to only the newest 2 pages.

TraverseAllPages will increase the request time for completion, based on how many entries there is in the history.
Please be patient and let the system work for you.

Please note that when fetching more than 6-7 pages, you will start hitting the 429 throttling from the LCS API endpoint

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

### -EnvironmentId
Id of the environment that you want to be working against

```yaml
Type: String
Parameter Sets: SearchByEnvironmentId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnvironmentName
Name of the environment that you want to be working against

```yaml
Type: String
Parameter Sets: SearchByEnvironmentName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TraverseAllPages
Instruct the cmdlet to fetch all pages, until there isn't more data available

This can be a slow operation, as it has to call the LCS API multiple times, fetching a single page per call

```yaml
Type: SwitchParameter
Parameter Sets: Pagination
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstPages
Instruct the cmdlet how many pages that you want it to retrieve from the LCS API

Can only be used in combination with -TraverseAllPages

The default value is: 99 pages, which should be more than enough

Please note that when fetching more than 6-7 pages, you will start hitting the 429 throttling from the LCS API endpoint

```yaml
Type: Int32
Parameter Sets: Pagination
Aliases:

Required: False
Position: Named
Default value: 99
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

### PSCustomObject
## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
