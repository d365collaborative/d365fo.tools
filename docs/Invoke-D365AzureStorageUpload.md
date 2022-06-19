---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365AzureStorageUpload

## SYNOPSIS
Upload a file to Azure

## SYNTAX

### Default (Default)
```
Invoke-D365AzureStorageUpload [-AccountId <String>] [-AccessToken <String>] [-SAS <String>]
 [-Container <String>] -Filepath <String> [-ContentType <String>] [-DeleteOnUpload] [-EnableException]
 [<CommonParameters>]
```

### Pipeline
```
Invoke-D365AzureStorageUpload [-AccountId <String>] [-AccessToken <String>] [-SAS <String>]
 [-Container <String>] -Filepath <String> [-ContentType <String>] [-DeleteOnUpload] [-EnableException]
 [<CommonParameters>]
```

## DESCRIPTION
Upload any file to an Azure Storage Account

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365AzureStorageUpload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Filepath "c:\temp\bacpac\UAT_20180701.bacpac" -DeleteOnUpload
```

This will upload the "c:\temp\bacpac\UAT_20180701.bacpac" up to the "backupfiles" container, inside the "miscfiles" Azure Storage Account that is access with the "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" token.
After upload the local file will be deleted.

### EXAMPLE 2
```
$AzureParams = Get-D365ActiveAzureStorageConfig
```

PS C:\\\> New-D365Bacpac | Invoke-D365AzureStorageUpload @AzureParams

This will get the current Azure Storage Account configuration details and use them as parameters to upload the file to an Azure Storage Account.

### EXAMPLE 3
```
New-D365Bacpac | Invoke-D365AzureStorageUpload
```

This will generate a new bacpac file using the "New-D365Bacpac" cmdlet.
The file will be uploaded to an Azure Storage Account using the "Invoke-D365AzureStorageUpload" cmdlet.
This will use the default parameter values that are based on the configuration stored inside "Get-D365ActiveAzureStorageConfig" for the "Invoke-D365AzureStorageUpload" cmdlet.

### EXAMPLE 4
```
Invoke-D365AzureStorageUpload -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Filepath "c:\temp\bacpac\UAT_20180701.bacpac" -DeleteOnUpload
```

This will upload the "c:\temp\bacpac\UAT_20180701.bacpac" up to the "backupfiles" container, inside the "miscfiles" Azure Storage Account.
A SAS key is used to gain access to the container and uploading the file to it.

## PARAMETERS

### -AccountId
Storage Account Name / Storage Account Id where you want to store the file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:AzureStorageAccountId
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessToken
The token that has the needed permissions for the upload action

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:AzureStorageAccessToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -SAS
The SAS key that you have created for the storage account or blob container

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:AzureStorageSAS
Accept pipeline input: False
Accept wildcard characters: False
```

### -Container
Name of the blob container inside the storage account you want to store the file

```yaml
Type: String
Parameter Sets: (All)
Aliases: Blobname, Blob

Required: False
Position: Named
Default value: $Script:AzureStorageContainer
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filepath
Path to the file you want to upload

```yaml
Type: String
Parameter Sets: Default
Aliases: Path, File

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Pipeline
Aliases: Path, File

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ContentType
Media type of the file that is going to be uploaded

The value will be used for the blob property "Content Type".
If the parameter is left empty, the commandlet will try to automatically determined the value based on the file's extension.
If the parameter is left empty and the value cannot be automatically be determined, Azure storage will automatically assign "application/octet-stream" as the content type.
Valid media type values can be found here: https://www.iana.org/assignments/media-types/media-types.xhtml

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteOnUpload
Switch to tell the cmdlet if you want the local file to be deleted after the upload completes

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
Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Bacpac, Container

Author: Mötz Jensen (@Splaxi)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
