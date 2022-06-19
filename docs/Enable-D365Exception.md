---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Enable-D365Exception

## SYNOPSIS
Enable exceptions to be thrown

## SYNTAX

```
Enable-D365Exception [<CommonParameters>]
```

## DESCRIPTION
Change the default exception behavior of the module to support throwing exceptions

Useful when the module is used in an automated fashion, like inside Azure DevOps pipelines and large PowerShell scripts

## EXAMPLES

### EXAMPLE 1
```
Enable-D365Exception
```

This will for the rest of the current PowerShell session make sure that exceptions will be thrown.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Exception, Exceptions, Warning, Warnings

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Disable-D365Exception]()

