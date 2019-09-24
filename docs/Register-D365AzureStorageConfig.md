---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Register-D365AzureStorageConfig

## SYNOPSIS
Register Azure Storage Configurations

## SYNTAX

```
Register-D365AzureStorageConfig [[-ConfigStorageLocation] <String>] [<CommonParameters>]
```

## DESCRIPTION
Register all Azure Storage Configurations

## EXAMPLES

### EXAMPLE 1
```
Register-D365AzureStorageConfig -ConfigStorageLocation "System"
```

This will store all Azure Storage Configurations as defaults for all users on the machine.

## PARAMETERS

### -ConfigStorageLocation
Parameter used to instruct where to store the configuration objects

The default value is "User" and this will store all configuration for the active user

Valid options are:
"User"
"System"

"System" will store the configuration as default for all users, so they can access the configuration objects

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Configuration, Azure, Storage

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
