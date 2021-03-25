---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365DefaultModelForNewProjects

## SYNOPSIS
Set the default model used creating new projects in Visual Studio

## SYNTAX

```
Set-D365DefaultModelForNewProjects [-Module] <String> [<CommonParameters>]
```

## DESCRIPTION
Set the registered default model that is used across all new projects that are created inside Visual Studio when working with D365FO project types

It will backup the current "DynamicsDevConfig.xml" file, for you to revert the changes if anything should go wrong

## EXAMPLES

### EXAMPLE 1
```
Set-D365DefaultModelForNewProjects -Model "FleetManagement"
```

This will update the current default module registered in the "DynamicsDevConfig.xml" file.
This file is located in Documents\Visual Studio Dynamics 365\ or in Documents\Visual Studio 2015\Settings\ depending on the version.
It will backup the current "DynamicsDevConfig.xml" file.
It will replace the value inside the "DefaultModelForNewProjects" tag.

## PARAMETERS

### -Module
The name of the module / model that you want to be the default model for all new projects used inside Visual Studio when working with D365FO project types

```yaml
Type: String
Parameter Sets: (All)
Aliases: Model

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tag: Model, Models, Development, Default Model, Module, Project

Author: Mötz Jensen (@Splaxi)

The work for this cmdlet / function was inspired by Robin Kretzschmar (@DarkSmile92) blog post about changing the default model.

The direct link for his blog post is: https://robscode.onl/d365-set-default-model-for-new-projects/

His main blog can found here: https://robscode.onl/

## RELATED LINKS
