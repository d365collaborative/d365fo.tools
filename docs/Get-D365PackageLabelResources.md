---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365PackageLabelResources

## SYNOPSIS
Get label from the resource file

## SYNTAX

### Default (Default)
```
Get-D365PackageLabelResources -FilePath <String> [-Name <String>] [-Value <String>] [-IncludePath]
 [<CommonParameters>]
```

### Specific
```
Get-D365PackageLabelResources -FilePath <String> [-Name <String>] [-Value <String>] [-IncludePath]
 [<CommonParameters>]
```

## DESCRIPTION
Get label details from the resource file for a Dynamics 365 Finance & Operations environment

## EXAMPLES

### EXAMPLE 1
```
Get-D365PackageLabelResources -Path "C:\AOSService\PackagesLocalDirectory\ApplicationSuite\Resources\en-US\PRO.resources.dll"
```

Will get all labels from the "PRO.resouce.dll" file

The language is determined by the path to the resource file and nothing else

### EXAMPLE 2
```
Get-D365PackageLabelResources -Path "C:\AOSService\PackagesLocalDirectory\ApplicationSuite\Resources\en-US\PRO.resources.dll" -Name "@PRO505"
```

Will get the label with the name "@PRO505" from the "PRO.resouce.dll" file

The language is determined by the path to the resource file and nothing else

### EXAMPLE 3
```
Get-D365PackageLabelResources -Path "C:\AOSService\PackagesLocalDirectory\ApplicationSuite\Resources\en-US\PRO.resources.dll" -Value "*qty*"
```

Will get all the labels where the value fits the search "*qty*" from the "PRO.resouce.dll" file

The language is determined by the path to the resource file and nothing else

### EXAMPLE 4
```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelResourceFile -Language "da" | Get-D365PackageLabelResources -value "*batch*" -IncludePath
```

Will get all the labels, across all label files, for the "ApplicationSuite", where the language is "da" and where the label value fits the search "*batch*".

The path to the label file is included in the output.

## PARAMETERS

### -FilePath
The path to resource file that you want to get label details from

```yaml
Type: String
Parameter Sets: Default
Aliases: Path

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Specific
Aliases: Path

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the label you are looking for

Accepts wildcards for searching.
E.g.
-Name "@PRO*"

Default value is "*" which will search for all labels in the resource file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Value of the label you are looking for

Accepts wildcards for searching.
E.g.
-Name "*Qty*"

Default value is "*" which will search for all values in the resource file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludePath
Switch to indicate whether you want the result set to include the path to the resource file or not

Default is OFF - path details will not be part of the output

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
Tags: PackagesLocalDirectory, Label, Labels, Language, Development, Servicing, Resource, Resources

Author: Mötz Jensen (@Splaxi)

There are several advanced scenarios for this cmdlet.
See more on github and the wiki pages.

## RELATED LINKS
