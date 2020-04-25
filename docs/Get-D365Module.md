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
Get-D365Module [[-Name] <String>] [-ExcludeBinaryModules] [[-BinDir] <String>] [[-PackageDirectory] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get installed package / module from the machine running the AOS service for Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365Module
```

Shows the entire list of installed packages / modules located in the default location on the machine.

A result set example:

ModuleName                               IsBinary Version         References
----------                               -------- -------         ----------
AccountsPayableMobile                    False    10.0.9107.14827 {ApplicationFoundation, ApplicationPlatform, Appli...
ApplicationCommon                        False    10.0.8008.26462 {ApplicationFoundation, ApplicationPlatform}
ApplicationFoundation                    False    7.0.5493.35504  {ApplicationPlatform}
ApplicationFoundationFormAdaptor         False    7.0.4841.35227  {ApplicationPlatform, ApplicationFoundation, TestE...
Custom                                   True     10.0.0.0        {ApplicationPlatform}

### EXAMPLE 2
```
Get-D365Module -ExcludeBinaryModules
```

Outputs the all packages / modules that are NOT binary.
Will only include modules that is IsBinary = "False".

A result set example:

ModuleName                               IsBinary Version         References
----------                               -------- -------         ----------
AccountsPayableMobile                    False    10.0.9107.14827 {ApplicationFoundation, ApplicationPlatform, Appli...
ApplicationCommon                        False    10.0.8008.26462 {ApplicationFoundation, ApplicationPlatform}
ApplicationFoundation                    False    7.0.5493.35504  {ApplicationPlatform}
ApplicationFoundationFormAdaptor         False    7.0.4841.35227  {ApplicationPlatform, ApplicationFoundation, TestE...

### EXAMPLE 3
```
Get-D365Module -Name "Application*Adaptor"
```

Shows the list of installed packages / modules where the name fits the search "Application*Adaptor".

A result set example:

ModuleName                               IsBinary Version         References
----------                               -------- -------         ----------
ApplicationFoundationFormAdaptor         False    7.0.4841.35227  {ApplicationPlatform, ApplicationFoundation, TestE...
ApplicationPlatformFormAdaptor           False    7.0.4841.35227  {ApplicationPlatform, TestEssentials}
ApplicationSuiteFormAdaptor              False    10.0.9107.14827 {ApplicationFoundation, ApplicationPlatform, Appli...
ApplicationWorkspacesFormAdaptor         False    10.0.9107.14827 {ApplicationFoundation, ApplicationPlatform, Appli...

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

### -ExcludeBinaryModules
Instruct the cmdlet to exclude binary modules from the output

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
