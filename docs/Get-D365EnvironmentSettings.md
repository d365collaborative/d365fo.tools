---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365EnvironmentSettings

## SYNOPSIS
Get the D365FO environment settings

## SYNTAX

```
Get-D365EnvironmentSettings [<CommonParameters>]
```

## DESCRIPTION
Gets all settings the Dynamics 365 for Finance & Operations environment uses.

## EXAMPLES

### EXAMPLE 1
```
Get-D365EnvironmentSettings
```

This will get all details available for the environment

### EXAMPLE 2
```
Get-D365EnvironmentSettings | Format-Custom -Property *
```

This will get all details available for the environment and format it to show all details in a long 
custom object.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations. 
The call to the dll file gets all relevant details for the installation.

## RELATED LINKS
