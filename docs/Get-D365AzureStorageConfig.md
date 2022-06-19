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
Get-D365AzureStorageConfig [[-Name] <String>] [-OutputAsHashtable] [<CommonParameters>]
```

## DESCRIPTION
Get all Azure Storage Account configuration objects from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365AzureStorageConfig
```

This will show all Azure Storage Account configs

### EXAMPLE 2
```
Get-D365AzureStorageConfig -OutputAsHashtable
```

This will show all Azure Storage Account configs.
Every object will be output as a hashtable, for you to utilize as parameters for other cmdlets.

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
Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, Container

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
