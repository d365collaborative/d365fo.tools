---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsDatabaseOperationStatus

## SYNOPSIS
Get the status of a database operation from LCS

## SYNTAX

```
Get-D365LcsDatabaseOperationStatus [[-ProjectId] <Int32>] [[-BearerToken] <String>]
 [-OperationActivityId] <String> [-EnvironmentId] <String> [[-LcsApiUri] <String>] [-WaitForCompletion]
 [[-SleepInSeconds] <Int32>] [[-RetryTimeout] <TimeSpan>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Get the current status of a database operation against an environment from a LCS project

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsDatabaseOperationStatus -ProjectId 123456789 -OperationActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will check the database operation status of a specific OperationActivityId against an environment.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The OperationActivityId is identified by the OperationActivityId 123456789, which is obtained from executing either the Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets.
The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

### EXAMPLE 2
```
Get-D365LcsDatabaseOperationStatus -OperationActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
```

This will check the database operation status of a specific OperationActivityId against an environment.
The OperationActivityId is identified by the OperationActivityId 123456789, which is obtained from executing either the Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets.
The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 3
```
Get-D365LcsDatabaseOperationStatus -OperationActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -WaitForCompletion
```

This will check the database operation status of a specific OperationActivityId against an environment.
The OperationActivityId is identified by the OperationActivityId 123456789, which is obtained from executing either the Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets.
The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
The cmdlet will every 300 seconds contact the LCS API endpoint and check if the status of the database operation status is either success or failure.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 4
```
Get-D365LcsDatabaseOperationStatus -OperationActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -RetryTimeout "00:01:00"
```

This will check the database operation status of a specific OperationActivityId against an environment, and allow for the cmdlet to retry for no more than 1 minute.
The OperationActivityId is identified by the OperationActivityId 123456789, which is obtained from executing either the Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets.
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

### -OperationActivityId
The unique id of the operaction activity that identitfies the database operation

It will be part of the output from the different Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets

```yaml
Type: String
Parameter Sets: (All)
Aliases: ActivityId

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnvironmentId
The unique id of the environment that you want to work against

The Id can be located inside the LCS portal

```yaml
Type: String
Parameter Sets: (All)
Aliases: SourceEnvironmentId

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Position: 5
Default value: $Script:LcsApiLcsApiUri
Accept pipeline input: False
Accept wildcard characters: False
```

### -WaitForCompletion
Instruct the cmdlet to wait for the deployment process to complete

The cmdlet will sleep for 300 seconds, before requesting the status of the deployment process from LCS

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

### -SleepInSeconds
Time in seconds that you want the cmdlet to use as the sleep timer between each request against the LCS endpoint

Default value is 300

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 300
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
Position: 7
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
Tags: Environment, Config, Configuration, LCS, Database backup, Api, Backup, Restore, Refresh

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Get-D365LcsAssetValidationStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsDeployment]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

