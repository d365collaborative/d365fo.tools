---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365DefaultModelForNewProjects

## SYNOPSIS
Get the default model used creating new projects in Visual Studio

## SYNTAX

```
Get-D365DefaultModelForNewProjects [<CommonParameters>]
```

## DESCRIPTION
Get the registered default model that is used across all new projects that are created inside Visual Studio when working with D365FO project types

## EXAMPLES

### EXAMPLE 1
```
Get-D365DefaultModelForNewProjects
```

This will display the current default module registered in the "DynamicsDevConfig.xml" file.
Located in Documents\Visual Studio Dynamics 365\ or in Documents\Visual Studio 2015\Settings\ depending on the version.

## PARAMETERS

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
