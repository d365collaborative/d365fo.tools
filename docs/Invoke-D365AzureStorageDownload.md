---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365AzureStorageDownload

## SYNOPSIS
Download a file to Azure

## SYNTAX

### Default (Default)
```
Invoke-D365AzureStorageDownload [[-AccountId] <String>] [[-AccessToken] <String>] [[-Blobname] <String>]
 [-FileName] <String> [-Path] <String> [<CommonParameters>]
```

### Latest
```
Invoke-D365AzureStorageDownload [[-AccountId] <String>] [[-AccessToken] <String>] [[-Blobname] <String>]
 [-Path] <String> [-GetLatest] [<CommonParameters>]
```

## DESCRIPTION
Download any file to an Azure Storage Account

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365AzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -FileName "OriginalUAT.bacpac" -Path "c:\temp"
```

Will download the "OriginalUAT.bacpac" file from the storage account and save it to "c:\temp\OriginalUAT.bacpac"

### EXAMPLE 2
```
Invoke-D365AzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Path "c:\temp" -GetLatest
```

Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
The complete path to the file will returned as output from the cmdlet.

### EXAMPLE 3
```
$AzureParams = Get-D365ActiveAzureStorageConfig
```

PS C:\\\> Invoke-D365AzureStorageDownload @AzureParams -Path "c:\temp" -GetLatest

This will get the current Azure Storage Account configuration details
and use them as parameters to download the latest file from an Azure Storage Account

Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
The complete path to the file will returned as output from the cmdlet.

## PARAMETERS

### -AccountId
Storage Account Name / Storage Account Id where you want to fetch the file from

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
The token that has the needed permissions for the download action

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
Name of the container / blog inside the storage account you where the file is

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

### -FileName
Name of the file that you want to download

```yaml
Type: String
Parameter Sets: Default
Aliases: Name

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
Path to the folder / location you want to save the file

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

### -GetLatest
Switch to tell the cmdlet just to download the latest file from Azure regardless of name

```yaml
Type: SwitchParameter
Parameter Sets: Latest
Aliases:

Required: True
Position: 5
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
