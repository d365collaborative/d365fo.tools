---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365LcsDatabaseExport

## SYNOPSIS
Start a database export from an environment

## SYNTAX

```
Invoke-D365LcsDatabaseExport [[-ProjectId] <Int32>] [[-BearerToken] <String>] [-SourceEnvironmentId] <String>
 [-BackupName] <String> [[-LcsApiUri] <String>] [-SkipInitialStatusFetch] [-FailOnErrorMessage]
 [[-RetryTimeout] <TimeSpan>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Start a database export from an environment from a LCS project

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365LcsDatabaseExport -ProjectId 123456789 -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BackupName "BackupViaApi" -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will start the database export from the Source environment.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The backup name is identified by the BackupName "BackupViaApi", which instructs the API to save the backup with that filename.
The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

### EXAMPLE 2
```
Invoke-D365LcsDatabaseExport -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BackupName "BackupViaApi"
```

This will start the database export from the Source environment.
The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The backup name is identified by the BackupName "BackupViaApi", which instructs the API to save the backup with that filename.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 3
```
$databaseExport = Invoke-D365LcsDatabaseExport -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BackupName "BackupViaApi" -SkipInitialStatusFetch
```

PS C:\\\> $databaseExport | Get-D365LcsDatabaseOperationStatus -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e9" -SleepInSeconds 60

This will start the database export from the Source environment.
The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The backup name is identified by the BackupName "BackupViaApi", which instructs the API to save the backup with that filename.
It will skip the first database operation status fetch and only output the details from starting the export.

The output from Invoke-D365LcsDatabaseExport is stored in the $databaseExport.
This will enable you to pass the $databaseExport variable to other cmdlets which should make things easier for you.

Will pipe the $databaseExport variable to the Get-D365LcsDatabaseOperationStatus cmdlet and get the status from the database export job.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 4
```
Invoke-D365LcsDatabaseExport -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BackupName "BackupViaApi" -SkipInitialStatusFetch
```

This will start the database export from the Source environment.
The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The backup name is identified by the BackupName "BackupViaApi", which instructs the API to save the backup with that filename.
It will skip the first database operation status fetch and only output the details from starting the export.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 5
```
Invoke-D365LcsDatabaseExport -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BackupName "BackupViaApi" -RetryTimeout "00:01:00"
```

This will start the database export from the Source environment, and allow for the cmdlet to retry for no more than 1 minute.
The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The backup name is identified by the BackupName "BackupViaApi", which instructs the API to save the backup with that filename.

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

### -SourceEnvironmentId
The unique id of the environment that you want to use as the source for the database export

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

### -BackupName
Name of the backup file when it is being exported from the environment

The file shouldn't contain any extension at all, just the desired file name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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
Position: 5
Default value: $Script:LcsApiLcsApiUri
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipInitialStatusFetch
Instruct the cmdlet to skip the first fetch of the database refresh status

Useful when you have a large script that handles this status validation and you don't want to spend time with this cmdlet

Default output from this cmdlet is 2 (two) different objects.
The first object is the response object for starting the export operation.
The second object is the response object from fetching the status of the export operation.

Setting this parameter (activate it), will affect the number of output objects.
If you skip, only the first response object outputted.

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
Position: 6
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
The ActivityId property is a custom property that ISN'T part of the response from the LCS API.
The ActivityId is always the same as the OperationActivityId (original LCS property).
The EnvironmentId property is a custom property that ISN'T part of the response from the LCS API.
The EnvironmentId is always the same as the SourceEnvironmentId parameter you have supplied to this cmdlet.

Default output from this cmdlet is 2 (two) different objects.
The first object is the response object for starting the export operation.
The second object is the response object from fetching the status of the export operation.

Setting the SkipInitialStatusFetch parameter (activate it), will affect the number of output objects.
If you skip, only the first response object outputted.

Running with the default (SkipInitialStatusFetch NOT being set), will instruct the cmdlet to call the Get-D365LcsDatabaseOperationStatus cmdlet.
This will output a second object, with other properties than the first object outputted.

Tags: Environment, Config, Configuration, LCS, Database backup, Api, Backup, Bacpac

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsDatabaseOperationStatus]()

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Get-D365LcsAssetValidationStatus]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

