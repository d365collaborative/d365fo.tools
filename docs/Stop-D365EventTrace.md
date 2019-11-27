---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Stop-D365EventTrace

## SYNOPSIS
Stop an Event Trace session

## SYNTAX

```
Stop-D365EventTrace [[-SessionName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Stop an Event Trace session that you have started earlier with the d365fo.tools

## EXAMPLES

### EXAMPLE 1
```
Stop-D365EventTrace
```

This will stop an Event Trace session.
It will use the "d365fo.tools.trace" as the SessionName parameter.

## PARAMETERS

### -SessionName
Name of the tracing session that you want to stop

Default value is "d365fo.tools.trace"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: D365fo.tools.trace
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
