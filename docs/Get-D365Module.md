---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Module

## SYNOPSIS
Get installed package / module from Dynamics 365 Finance & Operations environment

## SYNTAX

```
Get-D365Module [[-Name] <String>] [[-BinDir] <String>] [[-PackageDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get installed package / module from the machine running the AOS service for Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365Module
```

Shows the entire list of installed packages / modules located in the default location on the machine.

### EXAMPLE 2
```
Get-D365Module -Name "Application*Adaptor"
```

Shows the list of installed packages / modules where the name fits the search "Application*Adaptor".

A result set example:
ApplicationFoundationFormAdaptor
ApplicationPlatformFormAdaptor
ApplicationSuiteFormAdaptor
ApplicationWorkspacesFormAdaptor

### EXAMPLE 3
```
Get-D365Module -Name "Application*Adaptor" -Expand
```

Shows the list of installed packages / modules where the name fits the search "Application*Adaptor".
Will include the file version for each package / module.

### EXAMPLE 4
```
Get-D365Module -PackageDirectory "J:\AOSService\PackagesLocalDirectory"
```

Shows the entire list of installed packages / modules located in "J:\AOSService\PackagesLocalDirectory" on the machine

## PARAMETERS

### -Name
Name of the package / module that you are looking for

Accepts wildcards for searching.
E.g.
-Name "Application*Adaptor"

Default value is "*" which will search for all packages / modules

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: PackagesLocalDirectory, Servicing, Model, Models, Package, Packages

Author: Mötz Jensen (@Splaxi)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
