---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365PackageLabelFile

## SYNOPSIS
Get label file from a package

## SYNTAX

### Default (Default)
```
Get-D365PackageLabelFile [-PackageDirectory] <String> [[-Name] <String>] [[-Language] <String>]
 [<CommonParameters>]
```

### Specific
```
Get-D365PackageLabelFile [-PackageDirectory] <String> [[-Name] <String>] [[-Language] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get label file (resource file) from the package directory

## EXAMPLES

### EXAMPLE 1
```
Get-D365PackageLabelFile -PackageDirectory "C:\AOSService\PackagesLocalDirectory\ApplicationSuite"
```

Shows all the label files for ApplicationSuite package

### EXAMPLE 2
```
Get-D365PackageLabelFile -PackageDirectory "C:\AOSService\PackagesLocalDirectory\ApplicationSuite" -Name "Fixed*Accounting"
```

Shows the label files for ApplicationSuite package where the name fits the search "Fixed*Accounting"

### EXAMPLE 3
```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile
```

Shows all label files (en-US) for the ApplicationSuite package

## PARAMETERS

### -PackageDirectory
Path to the package that you want to get a label file from

```yaml
Type: String
Parameter Sets: Default
Aliases: Path

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Specific
Aliases: Path

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the label file you are looking for

Accepts wildcards for searching.
E.g.
-Name "Fixed*Accounting"

Default value is "*" which will search for all label files

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
Position: 4
Default value: En-US
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
