---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Url

## SYNOPSIS
Get the url for accessing the instance

## SYNTAX

```
Get-D365Url [-Force] [<CommonParameters>]
```

## DESCRIPTION
Get the complete URL for accessing the Dynamics 365 Finance & Operations instance running on this machine

## EXAMPLES

### EXAMPLE 1
```
Get-D365Url
```

This will get the correct URL to access the environment

## PARAMETERS

### -Force
Switch to instruct the cmdlet to retrieve the name from the system files
instead of the name stored in memory after loading this module.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: URL, URI, Servicing

Author: Rasmus Andersen (@ITRasmus)

The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations.
The call to the dll file gets all registered URL for the environment.

## RELATED LINKS
