---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Disable-D365Exception

## SYNOPSIS
Disables throwing of exceptions

## SYNTAX

```
Disable-D365Exception [<CommonParameters>]
```

## DESCRIPTION
Restore the default exception behavior of the module to not support throwing exceptions

Useful when the default behavior was changed with Enable-D365Exception and the default behavior should be restored

## EXAMPLES

### EXAMPLE 1
```
Disable-D365Exception
```

This will restore the default behavior of the module to not support throwing exceptions.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Exception, Exceptions, Warning, Warnings

Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS

[Enable-D365Exception]()

