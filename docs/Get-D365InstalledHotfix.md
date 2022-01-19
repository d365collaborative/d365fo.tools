---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365InstalledHotfix

## SYNOPSIS
Get installed hotfix (DEPRECATED)

## SYNTAX

```
Get-D365InstalledHotfix [[-BinDir] <String>] [[-PackageDirectory] <String>] [[-Model] <String>]
 [[-Name] <String>] [[-KB] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get all relevant details for installed hotfixes on environments that are not on a "One Version" version.
This cmdlet is deprecated since 2021-10-05 and will be removed by 2022-04-05.

## EXAMPLES

### EXAMPLE 1
```
Get-D365InstalledHotfix
```

This will display all installed hotfixes found on this machine

### EXAMPLE 2
```
Get-D365InstalledHotfix -Model "*retail*"
```

This will display all installed hotfixes found for all models that matches the search for "*retail*" found on this machine

### EXAMPLE 3
```
Get-D365InstalledHotfix -Model "*retail*" -KB "*43*"
```

This will display all installed hotfixes found for all models that matches the search for "*retail*" and only with KB's that matches the search for "*43*" found on this machine

## PARAMETERS

### -BinDir
The path to the bin directory for the environment

Default path is the same as the AOS Service PackagesLocalDirectory\bin

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
Path to the PackagesLocalDirectory

Default path is the same as the AOS Service PackagesLocalDirectory

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

### -Model
Name of the model that you want to work against

Accepts wildcards for searching.
E.g.
-Model "*Retail*"

Default value is "*" which will search for all models

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the hotfix that you are looking for

Accepts wildcards for searching.
E.g.
-Name "7045*"

Default value is "*" which will search for all hotfixes

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

### -KB
KB number of the hotfix that you are looking for

Accepts wildcards for searching.
E.g.
-KB "4045*"

Default value is "*" which will search for all KB's

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Hotfix, Servicing, Model, Models, KB, Patch, Patching, PackagesLocalDirectory

Author: Mötz Jensen (@Splaxi)

This cmdlet is inspired by the work of "Ievgen Miroshnikov" (twitter: @IevgenMir)

All credits goes to him for showing how to extract these information

His blog can be found here:
https://ievgensaxblog.wordpress.com

The specific blog post that we based this cmdlet on can be found here:
https://ievgensaxblog.wordpress.com/2017/11/17/d365foe-get-list-of-installed-metadata-hotfixes-using-metadata-api/

## RELATED LINKS
