---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LabelFile

## SYNOPSIS
Get label file (ids) for packages / modules from Dynamics 365 Finance & Operations environment

## SYNTAX

```
Get-D365LabelFile [[-BinDir] <String>] [[-PackageDirectory] <String>] [[-Module] <String>] [[-Name] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get label file (ids) for packages / modules from the machine running the AOS service for Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365LabelFile
```

Shows the entire list of label file (ids) for all installed packages / modules located in the default location on the machine

### EXAMPLE 2
```
Get-D365LabelFile -Name "Acc*Receivable*"
```

Shows the list of label file (ids) for all installed packages / modules where the label file (ids) name fits the search "Acc*Receivable*"

A result set example:

LabelFileId                        Languages              Module
-----------                        ---------              ------
AccountsReceivable                 {ar-AE, ar, cs, da...} ApplicationSuite
AccountsReceivable_SalesTaxCodesSA {en-US}                ApplicationSuite

### EXAMPLE 3
```
Get-D365LabelFile -PackageDirectory "J:\AOSService\PackagesLocalDirectory"
```

Shows the list of label file (ids) for all installed packages / modules located in "J:\AOSService\PackagesLocalDirectory" on the machine

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

### -PackageDirectory
Path to the directory containing the installed package / module

Normally it is located under the AOSService directory in "PackagesLocalDirectory"

Default value is fetched from the current configuration on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:PackageDirectory
Accept pipeline input: False
Accept wildcard characters: False
```

### -Module
Name of the module that you want to work against

Default value is "*" which will search for all modules

```yaml
Type: String
Parameter Sets: (All)
Aliases: ModuleName

Required: False
Position: 4
Default value: *
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the label file (id) that you are looking for

Accepts wildcards for searching.
E.g.
-Name "Acc*Receivable*"

Default value is "*" which will search for all label file (ids)

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
