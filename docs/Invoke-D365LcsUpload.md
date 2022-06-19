---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365LcsUpload

## SYNOPSIS
Upload a file to a LCS project

## SYNTAX

```
Invoke-D365LcsUpload [[-ProjectId] <Int32>] [[-BearerToken] <String>] [-FilePath] <String>
 [[-FileType] <LcsAssetFileType>] [[-Name] <String>] [[-Filename] <String>] [[-FileDescription] <String>]
 [[-LcsApiUri] <String>] [-FailOnErrorMessage] [[-RetryTimeout] <TimeSpan>] [-EnableException]
 [<CommonParameters>]
```

## DESCRIPTION
Upload a file to a LCS project using the API provided by Microsoft

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365LcsUpload -ProjectId 123456789 -BearerToken "Bearer JldjfafLJdfjlfsalfd..." -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -FileType "SoftwareDeployablePackage" -Name "Release-2019-05-05" -Filename "Release-2019-05-05.zip" -FileDescription "Build based on sprint: SuperSprint-1" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will start the upload of a file to the Asset Library.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
The file type "Software Deployable Package" determines where inside the Asset Library the file will end up.
The name inside the Asset Library is based on the Name "Release-2019-05-05".
The file name inside the Asset Library is based on the FileName "Release-2019-05-05.zip".
The description inside the Asset Library is based on the FileDescription "Build based on sprint: SuperSprint-1".
The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

### EXAMPLE 2
```
Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -FileType "SoftwareDeployablePackage" -FileName "Release-2019-05-05.zip"
```

This will start the upload of a file to the Asset Library.
The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
The file type "Software Deployable Package" determines where inside the Asset Library the file will end up.
The file name inside the Asset Library is based on the FileName "Release-2019-05-05.zip".

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 3
```
Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip"
```

This will start the upload of a file to the Asset Library.
The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 4
```
Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -RetryTimeout "00:01:00"
```

This will start the upload of a file to the Asset Library through the LCS API, and allow for the cmdlet to retry for no more than 1 minute.
The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".

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

### -FilePath
Path to the file that you want to upload to the Asset Library on LCS

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

### -FileType
Type of file you want to upload

Valid options:
"Model"
"Process Data Package"
"Software Deployable Package"
"GER Configuration"
"Data Package"
"PowerBI Report Model"
"E-Commerce Package"
"NuGet Package"
"Retail Self-Service Package"
"Commerce Cloud Scale Unit Extension"

Default value is "Software Deployable Package"

```yaml
Type: LcsAssetFileType
Parameter Sets: (All)
Aliases:
Accepted values: Model, ProcessDataPackage, SoftwareDeployablePackage, GERConfiguration, DataPackage, PowerBIReportModel, ECommercePackage, NuGetPackage, RetailSelfServicePackage, CommerceCloudScaleUnitExtension

Required: False
Position: 4
Default value: SoftwareDeployablePackage
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name to be assigned / shown on LCS

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filename
Filename to be assigned / shown on LCS

Often will it require an extension for it to be accepted

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileDescription
Description to be assigned / shown on LCS

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
Position: 8
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
Position: 9
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
Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Get-D365LcsAssetValidationStatus]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsDeployment]()

[Set-D365LcsApiConfig]()

