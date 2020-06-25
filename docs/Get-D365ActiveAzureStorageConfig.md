---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365ActiveAzureStorageConfig

## SYNOPSIS
Get active Azure Storage Account configuration

## SYNTAX

```
Get-D365ActiveAzureStorageConfig [-OutputAsPsCustomObject] [<CommonParameters>]
```

## DESCRIPTION
Get active Azure Storage Account configuration object from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365ActiveAzureStorageConfig
```

This will get the active Azure Storage configuration.

### EXAMPLE 2
```
Get-D365ActiveAzureStorageConfig -OutputAsPsCustomObject
```

This will get the active Azure Storage configuration.
The object will be output as a PsCustomObject, for you to utilize across your scripts.

## PARAMETERS

### -OutputAsPsCustomObject
Instruct the cmdlet to return a PsCustomObject object

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
