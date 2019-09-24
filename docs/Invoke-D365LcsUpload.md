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
 [[-FileType] <String>] [[-FileName] <String>] [[-FileDescription] <String>] [[-LcsApiUri] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Upload a file to a LCS project using the API provided by Microsoft

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365LcsUpload -ProjectId 123456789 -BearerToken "Bearer JldjfafLJdfjlfsalfd..." -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -FileType "Software Deployable Package" -FileName "Release-2019-05-05" -FileDescription "Build based on sprint: SuperSprint-1" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will start the upload of a file to the Asset Library.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
The file type "Software Deployable Package" determines where inside the Asset Library the file will end up.
The name inside the Asset Library is based on the FileName "Release-2019-05-05".
The description inside the Asset Library is based on the FileDescription "Build based on sprint: SuperSprint-1".
The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

### EXAMPLE 2
```
Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -FileType "Software Deployable Package" -FileName "Release-2019-05-05"
```

This will start the upload of a file to the Asset Library.
The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
The file type "Software Deployable Package" determines where inside the Asset Library the file will end up.
The name inside the Asset Library is based on the FileName "Release-2019-05-05".

All default values will come from the configuration available from Get-D365LcsApiConfig.

### EXAMPLE 3
```
Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip"
```

This will start the upload of a file to the Asset Library.
The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".

All default values will come from the configuration available from Get-D365LcsApiConfig.

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

Default value is "Software Deployable Package"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Software Deployable Package
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
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

### -FileDescription
Description to be assigned / shown on LCS

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

### -LcsApiUri
URI / URL to the LCS API you want to use

Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's

Valid options:
"https://lcsapi.lcs.dynamics.com"
"https://lcsapi.eu.lcs.dynamics.com"

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Script:LcsApiLcsApiUri
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

