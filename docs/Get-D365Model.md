---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Model

## SYNOPSIS
Get available model from Dynamics 365 Finance & Operations environment

## SYNTAX

```
Get-D365Model [[-Name] <String>] [[-Module] <String>] [-CustomizableOnly] [-ExcludeMicrosoftModels]
 [[-BinDir] <String>] [[-PackageDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get available model from the machine running the AOS service for Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365Model
```

Shows the entire list of installed models located in the default location on the machine.

A result set example:

ModelName                        Module                              Customization        Id Publisher
---------                        ------                              -------------        -- ---------
AccountsPayableMobile            AccountsPayableMobile               DoNotAllow    895571380 Microsoft Corporation
ApplicationCommon                ApplicationCommon                   DoNotAllow      8956718 Microsoft
ApplicationFoundation            ApplicationFoundation               Allow               450 Microsoft Corporation
ApplicationFoundationFormAdaptor ApplicationFoundationFormAdaptor    DoNotAllow       855029 Microsoft Corporation
ApplicationPlatform              ApplicationPlatform                 Allow               400 Microsoft Corporation

### EXAMPLE 2
```
Get-D365Model -CustomizableOnly
```

Shows only the models that are marked as customizable.
Will only include models that is Customization = "Allow".

A result set example:

ModelName                        Module                              Customization        Id Publisher
---------                        ------                              -------------        -- ---------
ApplicationFoundation            ApplicationFoundation               Allow               450 Microsoft Corporation
ApplicationPlatform              ApplicationPlatform                 Allow               400 Microsoft Corporation
ApplicationPlatformFormAdaptor   ApplicationPlatformFormAdaptor      Allow            855030 Microsoft Corporation
AtlCostAccounting                AtlCostAccounting                   Allow         895972481 Microsoft
AtlMaterialhandling              AtlMaterialhandling                 Allow         895972595 Microsoft Corporation

### EXAMPLE 3
```
Get-D365Model -Name "Application*Adaptor"
```

Shows the list of models where the name fits the search "Application*Adaptor".

A result set example:

ModelName                        Module                           Customization     Id Publisher
---------                        ------                           -------------     -- ---------
ApplicationFoundationFormAdaptor ApplicationFoundationFormAdaptor DoNotAllow    855029 Microsoft Corporation
ApplicationPlatformFormAdaptor   ApplicationPlatformFormAdaptor   Allow         855030 Microsoft Corporation
ApplicationSuiteFormAdaptor      ApplicationSuiteFormAdaptor      DoNotAllow    855028 Microsoft Corporation
ApplicationWorkspacesFormAdaptor ApplicationWorkspacesFormAdaptor DoNotAllow    855066 Microsoft Corporation

### EXAMPLE 4
```
Get-D365Model -Module ApplicationSuite
```

Shows only the models that are inside the ApplicationSuite module.

A result set example:

ModelName                                          Module           Customization        Id Publisher
---------                                          ------           -------------        -- ---------
Electronic Reporting Application Suite Integration ApplicationSuite DoNotAllow       855009 Microsoft Corporation
Foundation                                         ApplicationSuite DoNotAllow           17 Microsoft Corporation
SCMControls                                        ApplicationSuite DoNotAllow       855891 Microsoft Corporation
Tax Books Application Suite Integration            ApplicationSuite DoNotAllow    895570102 Microsoft Corporation
Tax Engine Application Suite Integration           ApplicationSuite DoNotAllow      8957001 Microsoft Corporation

### EXAMPLE 5
```
Get-D365Model -Name "*Application*" -Module "*Suite*"
```

Shows the list of models where the name fits the search "*Application*" and the module name fits the search "*Suite*".

A result set example:

ModelName                                          Module                      Customization        Id Publisher
---------                                          ------                      -------------        -- ---------
ApplicationSuiteFormAdaptor                        ApplicationSuiteFormAdaptor DoNotAllow       855028 Microsoft Cor...
AtlApplicationSuite                                AtlApplicationSuite         DoNotAllow    895972466 Microsoft Cor...
Electronic Reporting Application Suite Integration ApplicationSuite            DoNotAllow       855009 Microsoft Cor...
Tax Books Application Suite Integration            ApplicationSuite            DoNotAllow    895570102 Microsoft Cor...
Tax Engine Application Suite Integration           ApplicationSuite            DoNotAllow      8957001 Microsoft Cor...

## PARAMETERS

### -Name
Name of the model that you are looking for

Accepts wildcards for searching.
E.g.
-Name "Application*Adaptor"

Default value is "*" which will search for all models

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

### -Module
Name of the module that you want to list models from

Accepts wildcards for searchinf.
E.g.
-Module "Application*Adaptor"

Default value is "*" which will search across all modules

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CustomizableOnly
Instructs the cmdlet to filter our all models that cannot be customized

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

### -ExcludeMicrosoftModels
{{ Fill ExcludeMicrosoftModels Description }}

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
Position: 3
Default value: "$Script:BinDir\bin"
Accept pipeline input: False
Accept wildcard characters: False
```

### -PackageDirectory
Path to the directory containing the installed package / module

Default path is the same as the AOS service "PackagesLocalDirectory" directory

Default value is fetched from the current configuration on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:PackageDirectory
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: PackagesLocalDirectory, Servicing, Model, Models, Module, Modules

Author: Mötz Jensen (@Splaxi)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
