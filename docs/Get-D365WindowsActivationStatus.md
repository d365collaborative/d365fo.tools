---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365WindowsActivationStatus

## SYNOPSIS
Get activation status

## SYNTAX

```
Get-D365WindowsActivationStatus [<CommonParameters>]
```

## DESCRIPTION
Get all the important license and activation information from the machine

## EXAMPLES

### EXAMPLE 1
```
Get-D365WindowsActivationStatus
```

This will get the remaining grace and rearm activation information for the machine

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The cmdlet uses CIM objects to access the activation details

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
