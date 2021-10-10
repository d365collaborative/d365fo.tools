---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365PackageLabelResourceFile

## SYNOPSIS
Get label / resource file from a package

## SYNTAX

### Default (Default)
```
Get-D365PackageLabelResourceFile -PackageDirectory <String> [-Name <String>] [-Language <String>]
 [<CommonParameters>]
```

### Specific
```
Get-D365PackageLabelResourceFile -PackageDirectory <String> [-Name <String>] [-Language <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get label (resource) file from the package directory of a Dynamics 365 Finance & Operations environment

## EXAMPLES

### EXAMPLE 1
```
Get-D365PackageLabelResourceFile -PackageDirectory "C:\AOSService\PackagesLocalDirectory\ApplicationSuite"
```

Shows all the label files for ApplicationSuite package

### EXAMPLE 2
```
Get-D365PackageLabelResourceFile -PackageDirectory "C:\AOSService\PackagesLocalDirectory\ApplicationSuite" -Name "Fixed*Accounting"
```

Shows the label files for ApplicationSuite package where the name fits the search "Fixed*Accounting"

### EXAMPLE 3
```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelResourceFile
```

Shows all label files (en-US) for the ApplicationSuite package

## PARAMETERS

### -PackageDirectory
Path to the directory containing the installed packages

Normally it is located under the AOSService directory in "PackagesLocalDirectory"

Default value is fetched from the current configuration on the machine

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
Name of the label (resource) file you are looking for

Accepts wildcards for searching.
E.g.
-Name "Fixed*Accounting"

Default value is "*" which will search for all label files

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

### -Language
The language of the label file you are looking for

Accepts wildcards for searching.
E.g.
-Language "en*"

Default value is "en-US" which will search for en-US language files

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: En-US
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: PackagesLocalDirectory, Label, Labels, Language, Development, Servicing, Module, Package, Packages

Author: Mötz Jensen (@Splaxi)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
