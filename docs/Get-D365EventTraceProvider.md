---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365EventTraceProvider

## SYNOPSIS
Get D365FO Event Trace Provider

## SYNTAX

```
Get-D365EventTraceProvider [[-Name] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get the full list of available Event Trace Providers for Dynamics 365 for Finance and Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365EventTraceProvider
```

Will list all available Event Trace Providers on a D365FO server.
It will use the default option for the "Name" parameter.

### EXAMPLE 2
```
Get-D365EventTraceProvider -Name Tax
```

Will list all available Event Trace Providers on a D365FO server which contains the keyvword "Tax".
It will use the Name parameter value "Tax" while searching for Event Trace Providers.

### EXAMPLE 3
```
Get-D365EventTraceProvider -Name Tax,MR
```

Will list all available Event Trace Providers on a D365FO server which contains the keyvword "Tax" or "MR".
It will use the Name parameter array value ("Tax","MR") while searching for Event Trace Providers.

## PARAMETERS

### -Name
Name of the provider that you are looking for

Default value is "*" to show all Event Trace Providers

Accepts an array of names, and will automatically add wildcard searching characters for each entry

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: @("*")
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: ETL, EventTracing, EventTrace

Author: Mötz Jensen (@Splaxi)

This cmdlet/function was inspired by the work of Michael Stashwick (@D365Stuff)

He blog is located here: https://www.d365stuff.co/

and the blogpost that pointed us in the right direction is located here: https://www.d365stuff.co/trace-batch-jobs-and-more-via-cmd-logman/

## RELATED LINKS
