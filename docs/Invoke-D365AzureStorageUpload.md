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
Invoke-D365AzureStorageUpload [[-AccountId] <String>] [[-AccessToken] <String>] [[-Blobname] <String>]
 [-Filepath] <String> [-DeleteOnUpload] [<CommonParameters>]
```

### Pipeline
```
Invoke-D365AzureStorageUpload [[-AccountId] <String>] [[-AccessToken] <String>] [[-Blobname] <String>]
 [-Filepath] <String> [-DeleteOnUpload] [<CommonParameters>]
```

## DESCRIPTION
Upload any file to an Azure Storage Account

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365AzureStorageUpload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Filepath "c:\temp\bacpac\UAT_20180701.bacpac" -DeleteOnUpload
```

This will upload the "c:\temp\bacpac\UAT_20180701.bacpac" up to the "backupfiles" container, inside the "miscfiles" Azure Storage Account that is access with the "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" token.
After upload the local file will be deleted.

### EXAMPLE 2
```
$AzureParams = Get-D365ActiveAzureStorageConfig
```

PS C:\\\> New-D365Bacpac | Invoke-D365AzureStorageUpload @AzureParams

This will get the current Azure Storage Account configuration details and use them as parameters to upload the file to an Azure Storage Account.

## PARAMETERS

### -AccountId
Storage Account Name / Storage Account Id where you want to store the file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:AccountId
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
Position: 3
Default value: $Script:AccessToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -Blobname
Name of the container / blog inside the storage account you want to store the file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:Blobname
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filepath
Path to the file you want to upload

```yaml
Type: String
Parameter Sets: Default
Aliases: File

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Pipeline
Aliases: File

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByValue)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
