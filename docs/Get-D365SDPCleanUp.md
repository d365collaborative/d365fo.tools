---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365SDPCleanUp

## SYNOPSIS
Get the cleanup retention period

## SYNTAX

```
Get-D365SDPCleanUp [<CommonParameters>]
```

## DESCRIPTION
Gets the configured retention period before updates are deleted

## EXAMPLES

### EXAMPLE 1
```
Get-D365SDPCleanUp
```

This will get the configured retention period from the registry

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: CleanUp, Retention, Servicing, Cut Off, DeployablePackage, Deployable Package

Author: Mötz Jensen (@Splaxi)

This cmdlet is based on the findings from Alex Kwitny (@AlexOnDAX)

See his blog for more info:
http://www.alexondax.com/2018/04/msdyn365fo-how-to-adjust-your.html

## RELATED LINKS
