---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Language

## SYNOPSIS
Get installed languages from Dynamics 365 Finance & Operations environment

## SYNTAX

```
Get-D365Language [[-BinDir] <String>] [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get installed languages from the running the Dynamics 365 Finance & Operations instance

## EXAMPLES

### EXAMPLE 1
```
Get-D365Language
```

Shows the entire list of installed languages that are available from the running instance

### EXAMPLE 2
```
Get-D365Language -Name "fr*"
```

Shows the list of installed languages where the name fits the search "fr*"

A result set example:
fr      French
fr-BE   French (Belgium)
fr-CA   French (Canada)
fr-CH   French (Switzerland)

## PARAMETERS

### -BinDir
Path to the directory containing the BinDir and its assemblies

Normally it is located under the AOSService directory in "PackagesLocalDirectory"

Default value is fetched from the current configuration on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: "$Script:BinDir\bin"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the language that you are looking for

Accepts wildcards for searching.
E.g.
-Name "fr*"

Default value is "*" which will search for all languages

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Tags: PackagesLocalDirectory, Servicing, Language, Labels, Label

Author: Mötz Jensen (@Splaxi)

This cmdlet is inspired by the work of "Pedro Tornich" (twitter: @ptornich)

All credits goes to him for showing how to extract these information

His github repository can be found here:
https://github.com/ptornich/LabelFileGenerator

## RELATED LINKS
