---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Tier2Params

## SYNOPSIS
Get a hashtable with all the stored parameters

## SYNTAX

```
Get-D365Tier2Params [<CommonParameters>]
```

## DESCRIPTION
Gets a hashtable with all the stored parameters to be used with Import-D365Bacpac or New-D365Bacpac for Tier 2 environments

## EXAMPLES

### EXAMPLE 1
```
$params = Get-D365Tier2Params
```

This will extract the stored parameters and create a hashtable object.
The hashtable is assigned to the $params variable.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
