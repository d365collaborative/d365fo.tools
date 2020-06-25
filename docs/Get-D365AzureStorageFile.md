---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365AzureStorageFile

## SYNOPSIS
Get a file from Azure

## SYNTAX

### Default (Default)
```
Get-D365AzureStorageFile [-AccountId <String>] [-AccessToken <String>] [-SAS <String>] [-Container <String>]
 [-Name <String>] [<CommonParameters>]
```

### Latest
```
Get-D365AzureStorageFile [-AccountId <String>] [-AccessToken <String>] [-SAS <String>] [-Container <String>]
 [-Latest] [<CommonParameters>]
```

## DESCRIPTION
Get all files from an Azure Storage Account

## EXAMPLES

### EXAMPLE 1
```
Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles"
```

This will get all files in the blob container "backupfiles".
It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access.

### EXAMPLE 2
```
Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Latest
```

This will get the latest (newest) file from the blob container "backupfiles".
It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access to the container.

### EXAMPLE 3
```
Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Name "*UAT*"
```

This will get all files in the blob container "backupfiles" that fits the "*UAT*" search value.
It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access to the container.

### EXAMPLE 4
```
Get-D365AzureStorageFile -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Latest
```

This will get the latest (newest) file from the blob container "backupfiles".
It will use the SAS key "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" to gain access to the container.

## PARAMETERS

### -AccountId
Storage Account Name / Storage Account Id where you want to look for files

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
The token that has the needed permissions for the search action

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
Name of the blob container inside the storage account you want to look for files

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

### -Name
Name of the file you are looking for

Accepts wildcards for searching.
E.g.
-Name "Application*Adaptor"

Default value is "*" which will search for all packages

```yaml
Type: String
Parameter Sets: Default
Aliases: FileName

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Latest
Instruct the cmdlet to only fetch the latest file from the Azure Storage Account

```yaml
Type: SwitchParameter
Parameter Sets: Latest
Aliases: GetLatest

Required: True
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
Tags: Azure, Azure Storage, Token, Blob, File, Container

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
