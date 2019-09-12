---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Label

## SYNOPSIS
Get label from the label file from Dynamics 365 Finance & Operations environment

## SYNTAX

```
Get-D365Label [[-BinDir] <String>] [-LabelFileId] <String> [[-Language] <String[]>] [[-Name] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get label from the label file from the running the Dynamics 365 Finance & Operations instance

## EXAMPLES

### EXAMPLE 1
```
Get-D365Label -LabelFileId PRO
```

Shows the entire list of labels that are available from the PRO label file.
The language is defaulted to "en-US".

### EXAMPLE 2
```
Get-D365Label -LabelFileId PRO -Language da
```

Shows the entire list of labels that are available from the PRO label file.
Shows only all "da" (Danish) labels.

### EXAMPLE 3
```
Get-D365Label -LabelFileId PRO -Name "@PRO59*"
```

Shows the labels available from the PRO label file where the name fits the search "@PRO59*"

A result set example:

Name                 Value                                                                            Language
----                 -----                                                                            --------
@PRO59               Indicates if the type of the rebate value. 
en-US
@PRO594              Pack consumption                                                                 en-US
@PRO595              Pack qty now being released to production in the BOM unit. 
en-US
@PRO596              Pack unit. 
en-US
@PRO597              Pack proposal for release in the packing unit. 
en-US
@PRO590              Constant pack qty                                                                en-US
@PRO593              Pack proposal release in BOM unit. 
en-US
@PRO598              Pack quantity now being released for the production in the packing unit. 
en-US

### EXAMPLE 4
```
Get-D365Label -LabelFileId PRO -Name "@PRO59*" -Language da,en-us
```

Shows the labels available from the PRO label file where the name fits the search "@PRO59*".
Shows for both "da" (Danish) and en-US (English)

## PARAMETERS

### -BinDir
The path to the bin directory for the environment

Default path is the same as the AOS service PackagesLocalDirectory\bin

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

### -LabelFileId
Name / Id of the label "file" that you want to work against

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Language
Name / string representation of the language / culture you want to work against

Default value is "en-US"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: En-US
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the label that you are looking for

Accepts wildcards for searching.
E.g.
-Name "@PRO59*"

Default value is "*" which will search for all labels

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
