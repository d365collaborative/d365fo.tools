---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365AzureStorageConfig

## SYNOPSIS
Get Azure Storage Account configs

## SYNTAX

```
Get-D365AzureStorageConfig [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get all Azure Storage Account configuration objects from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365AzureStorageConfig
```

This will show all Azure Storage Account configs

## PARAMETERS

### -Name
The name of the Azure Storage Account you are looking for

Default value is "*" to display all Azure Storage Account configs

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Azure, Azure Storage, Config, Configuration, Token, Blob

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
