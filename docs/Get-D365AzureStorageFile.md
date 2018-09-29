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

```
Get-D365AzureStorageFile [[-AccountId] <String>] [[-AccessToken] <String>] [[-Blobname] <String>]
 [[-Name] <String>] [-GetLatest] [<CommonParameters>]
```

## DESCRIPTION
Get all files from an Azure Storage Account

## EXAMPLES

### EXAMPLE 1
```
Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles"
```

Will get all files in the blob / container

### EXAMPLE 2
```
Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Name "*UAT*"
```

Will get all files in the blob / container that fits the "*UAT*" search value

## PARAMETERS

### -AccountId
Storage Account Name / Storage Account Id where you want to look for files

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
The token that has the needed permissions for the search action

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
Name of the container / blog inside the storage account you want to look for files

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

### -Name
Name of the file you are looking for

Accepts wildcards for searching.
E.g.
-Name "Application*Adaptor"

Default value is "*" which will search for all packages

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -GetLatest
Switch to instruct the cmdlet to only fetch the latest file from the Azure Storage Account

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

## RELATED LINKS
