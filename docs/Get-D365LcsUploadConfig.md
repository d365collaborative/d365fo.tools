---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsUploadConfig

## SYNOPSIS
Get the LCS configuration details

## SYNTAX

```
Get-D365LcsUploadConfig [[-OutputType] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get the LCS configuration details from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsUploadConfig
```

This will return the saved configuration for accessing the LCS API.
The object return will be a HashTable.

### EXAMPLE 2
```
Get-D365LcsUploadConfig -OutputType "PSCustomObject"
```

This will return the saved configuration for accessing the LCS API.
The object return will be a PSCustomObject.

## PARAMETERS

### -OutputType
The output type you want the cmdlet to return to you

Default value is "HashTable"

Valid options:
HashTable
PSCustomObject

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: HashTable
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
