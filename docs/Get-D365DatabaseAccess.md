---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365DatabaseAccess

## SYNOPSIS
Shows the Database Access information for the D365 Environment

## SYNTAX

```
Get-D365DatabaseAccess [<CommonParameters>]
```

## DESCRIPTION
Gets all database information from the D365 environment

## EXAMPLES

### EXAMPLE 1
```
Get-D365DatabaseAccess
```

This will get all relevant details, including connection details, for the database configured for the environment

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations.
The call to the dll file gets all relevant connections details for the database server.

Author: Rasmus Andersen (@ITRasmus)

## RELATED LINKS
