---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365AzCopyTransfer

## SYNOPSIS
Transfer a file using AzCopy

## SYNTAX

```
Invoke-D365AzCopyTransfer [-SourceUri] <String> [-DestinationUri] <String> [[-FileName] <String>]
 [-DeleteOnTransferComplete] [[-LogPath] <String>] [-ShowOriginalProgress] [-OutputCommandOnly] [-Force]
 [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Transfer a file using the AzCopy tool

You can upload a local file to an Azure Storage Blob Container

You can download a file located in an Azure Storage Blob Container to a local folder

You can transfer a file located in an Azure Storage Blob Container to another Azure Storage Blob Container, across regions and subscriptions, if you have SAS tokens/keys as part of your uri

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365AzCopyTransfer -SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=..." -DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac"
```

This will transfer a file from an Azure Storage Blob Container to a local folder/file on the machine.
The file that will be transfered/downloaded is SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".
The file will be transfered/downloaded to DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac".

If there exists a file already, the file will NOT be overwritten.

### EXAMPLE 2
```
Invoke-D365AzCopyTransfer -SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=..." -DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac" -Force
```

This will transfer a file from an Azure Storage Blob Container to a local folder/file on the machine.
The file that will be transfered/downloaded is SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".
The file will be transfered/downloaded to DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac".
If there exists a file already, the file will  be overwritten, because Force has been supplied.

### EXAMPLE 3
```
Invoke-D365AzCopyTransfer -SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=..." -DestinationUri "https://456.blob.core.windows.net/targetcontainer/filename?sv=2015-12-11&sr=..."
```

This will transfer a file from an Azure Storage Blob Container to another Azure Storage Blob Container.
The file that will be transfered/downloaded is SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".
The file will be transfered/downloaded to DestinationUri "https://456.blob.core.windows.net/targetcontainer/filename?sv=2015-12-11&sr=...".

For this to work, you need to make sure both SourceUri and DestinationUri has an valid SAS token/key included.

If there exists a file already, the file will NOT be overwritten.

### EXAMPLE 4
```
Invoke-D365AzCopyTransfer -SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=..." -DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac" -DeleteOnTransferComplete
```

This will transfer a file from an Azure Storage Blob Container to a local folder/file on the machine.
The file that will be transfered/downloaded is SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".
The file will be transfered/downloaded to DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac".

After the file has been transfered to your local "c:\temp\d365fo.tools\GOLDER.bacpac", it will be deleted from the SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".

### EXAMPLE 5
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

### -SourceUri
Source file uri that you want to transfer

```yaml
Type: String
Parameter Sets: (All)
Aliases: FileLocation, SourceUrl

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DestinationUri
Destination file uri that you want to transfer the file to

```yaml
Type: String
Parameter Sets: (All)
Aliases: DestinationFile

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
You might only pass a blob container or folder name in the DestinationUri parameter and want to give the transfered file another name than the original file name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DeleteOnTransferComplete
Instruct the cmdlet to delete the source file when done transfering

Default is $false which will leave the source file

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

### -LogPath
The path where the log file(s) will be saved

When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed

```yaml
Type: String
Parameter Sets: (All)
Aliases: LogDir

Required: False
Position: 4
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\AzCopy")
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowOriginalProgress
Instruct the cmdlet to show the standard output in the console

Default is $false which will silence the standard output

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

### -OutputCommandOnly
Instruct the cmdlet to only output the command that you would have to execute by hand

Will include full path to the executable and the needed parameters based on your selection

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

### -Force
Instruct the cmdlet to overwrite already existing file

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
Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Latest, Bacpac, Container, LCS, Asset, Library

Author: Mötz Jensen (@Splaxi)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
