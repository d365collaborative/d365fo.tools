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
Invoke-D365LcsUpload [[-ProjectId] <Int32>] [[-ClientId] <String>] [[-Username] <String>]
 [[-Password] <String>] [-FilePath] <String> [[-FileType] <String>] [[-FileName] <String>]
 [[-FileDescription] <String>] [[-LcsApiUri] <String>] [<CommonParameters>]
```

## DESCRIPTION
Upload a file to a LCS project using the API provided by Microsoft

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365LcsUpload -ProjectId 123456789 -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username claire@contoso.com -Password "pass@word1" -FilePath "C:\temp\d365fo.tools\GOLDEN.bacpac" -FileType "DatabaseBackup" -FileName "ReadyForTesting" -FileDescription "Contains all customers & vendors" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will upload the "C:\temp\d365fo.tools\GOLDEN.bacpac" file to the LCS project 123456789.
It will authenticate against the AAD with the ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929", the Username Claire@contoso.com and the Password "pass@word1".
The file will be placed in the sub folder "Database Backup".
The file will be named "ReadyForTesting" inside the Asset Library in LCS.
The file is uploaded against the NON-EUROPE LCS API.

### EXAMPLE 2
```
Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\GOLDEN.bacpac" -FileType "DatabaseBackup" -FileName "ReadyForTesting" -FileDescription "Contains all customers & vendors"
```

This will upload the "C:\temp\d365fo.tools\GOLDEN.bacpac" file.
The file will be placed in the sub folder "Database Backup".
The file will be named "ReadyForTesting" inside the Asset Library in LCS.

The ProjectId, ClientId, Username, Password and LcsApiUri parameters are read from the configuration storage, that is configured by the Set-D365LcsUploadConfig cmdlet.

## PARAMETERS

### -ProjectId
The project id for the Dynamics 365 for Finance & Operations project inside LCS

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:LcsUploadProjectid
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:LcsUploadClientid
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

Required: False
Position: 4
Default value: $Script:LcsUploadUsername
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password of the account that you want to impersonate

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:LcsUploadPassword
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
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileType
Type of file you want to upload

Valid options:
"DeployablePackage"
"DatabaseBackup"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: DatabaseBackup
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
Position: 8
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
Position: 9
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

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: $Script:LcsUploadApiUri
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
