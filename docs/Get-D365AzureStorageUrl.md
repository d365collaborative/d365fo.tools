---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365AzureStorageUrl

## SYNOPSIS
Get a blob Url from Azure Storage account

## SYNTAX

```
Get-D365AzureStorageUrl [[-AccountId] <String>] [[-SAS] <String>] [[-Container] <String>] [-OutputAsHashtable]
 [<CommonParameters>]
```

## DESCRIPTION
Get a valid blob container url from an Azure Storage Account

## EXAMPLES

### EXAMPLE 1
```
Get-D365AzureStorageUrl -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles"
```

This will generate a valid Url for the blob container in the Azure Storage Account.
It will use the AccountId "miscfiles" as the name of the storage account.
It will use the SAS key "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" to add the SAS token/key to the Url.
It will use the Container "backupfiles" as the container name in the Url.

### EXAMPLE 2
```
Get-D365AzureStorageUrl
```

This will generate a valid Url for the blob container in the Azure Storage Account.
It will use the default values that are configured using the Set-D365ActiveAzureStorageConfig cmdlet and view using the Get-D365ActiveAzureStorageConfig cmdlet.

### EXAMPLE 3
```
Get-D365AzureStorageUrl -OutputAsHashtable
```

This will generate a valid Url for the blob container in the Azure Storage Account.
It will use the default values that are configured using the Set-D365ActiveAzureStorageConfig cmdlet and view using the Get-D365ActiveAzureStorageConfig cmdlet.

The output object will be a Hashtable, which you can use as a parameter for other cmdlets.

### EXAMPLE 4
```
$DestinationParms = Get-D365AzureStorageUrl -OutputAsHashtable
```

PS C:\\\> $BlobFileDetails = Get-D365LcsDatabaseBackups -Latest | Invoke-D365AzCopyTransfer @DestinationParms
PS C:\\\> $BlobFileDetails | Invoke-D365AzCopyTransfer -DestinationUri "C:\Temp" -DeleteOnTransferComplete

This will transfer the lastest backup file from LCS Asset Library to your local "C:\Temp".
It will get a destination Url, for it to transfer the backup file between the LCS storage account and your own.
The newly transfered file, that lives in your own storage account, will then be downloaded to your local "c:\Temp".

After the file has been downloaded to your local "C:\Temp", it will be deleted from your own storage account.

## PARAMETERS

### -AccountId
Storage Account Name / Storage Account Id you want to work against

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:AzureStorageAccountId
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
Position: 2
Default value: $Script:AzureStorageSAS
Accept pipeline input: False
Accept wildcard characters: False
```

### -Container
Name of the blob container inside the storage account you want to work against

```yaml
Type: String
Parameter Sets: (All)
Aliases: Blobname, Blob

Required: False
Position: 3
Default value: $Script:AzureStorageContainer
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputAsHashtable
Instruct the cmdlet to return a hastable object

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
Tags: Azure, Azure Storage, Token, Blob, File, Container, LCS, Asset, Bacpac, Backup

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
