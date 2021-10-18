---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365InstalledPackage

## SYNOPSIS
Get installed package from Dynamics 365 Finance & Operations environment

## SYNTAX

```
Get-D365InstalledPackage [[-Name] <String>] [[-PackageDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get installed package from the machine running the AOS service for Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365InstalledPackage
```

Shows the entire list of installed packages located in the default location on the machine

A result set example:
ApplicationFoundationFormAdaptor
ApplicationPlatformFormAdaptor
ApplicationSuiteFormAdaptor
ApplicationWorkspacesFormAdaptor

### EXAMPLE 2
```
Get-D365InstalledPackage -Name "Application*Adaptor"
```

Shows the list of installed packages where the name fits the search "Application*Adaptor"

A result set example:
ApplicationFoundationFormAdaptor
ApplicationPlatformFormAdaptor
ApplicationSuiteFormAdaptor
ApplicationWorkspacesFormAdaptor

### EXAMPLE 3
```
Get-D365InstalledPackage -PackageDirectory "J:\AOSService\PackagesLocalDirectory"
```

Shows the entire list of installed packages located in "J:\AOSService\PackagesLocalDirectory" on the machine

A result set example:
ApplicationFoundationFormAdaptor
ApplicationPlatformFormAdaptor
ApplicationSuiteFormAdaptor
ApplicationWorkspacesFormAdaptor

## PARAMETERS

### -Name
Name of the package that you are looking for

Accepts wildcards for searching.
E.g.
-Name "Application*Adaptor"

Default value is "*" which will search for all packages

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

### -PackageDirectory
Path to the directory containing the installed packages

Normally it is located under the AOSService directory in "PackagesLocalDirectory"

Default value is fetched from the current configuration on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
