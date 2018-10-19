---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Add-D365AzureStorageConfig

## SYNOPSIS
Save an Azure Storage Account config

## SYNTAX

```
Add-D365AzureStorageConfig [-Name] <String> [-AccountId] <String> [-AccessToken] <String> [-Blobname] <String>
 [-Force] [<CommonParameters>]
```

## DESCRIPTION
Adds an Azure Storage Account config to the configuration store

## EXAMPLES

### EXAMPLE 1
```
Add-D365AzureStorageConfig -Name "UAT-Exports" -AccountId "1234" -AccessToken "dafdfasdfasdf" -Blob "testblob"
```

This will add an entry into the list of Azure Storage Accounts that is stored with the name "UAT-Exports" with AccountId "1234", AccessToken "dafdfasdfasdf" and Blob "testblob"

## PARAMETERS

### -Name
The logical name of the Azure Storage Account you are about to registered in the configuration store

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountId
The account id for the Azure Storage Account you want to register in the configuration store

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessToken
The access token for the Azure Storage Account you want to register in the configuration store

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

### -Blobname
The name of the blob inside the Azure Storage Account you want to register in the configuration store

```yaml
Type: String
Parameter Sets: (All)
Aliases: Blob

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Switch to instruct the cmdlet to overwrite already registered Azure Storage Account entry

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
You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
