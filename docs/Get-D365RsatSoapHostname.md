---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365RsatSoapHostname

## SYNOPSIS
Get the SOAP hostname for the D365FO environment

## SYNTAX

```
Get-D365RsatSoapHostname [<CommonParameters>]
```

## DESCRIPTION
Get the SOAP hostname from the IIS configuration, to be used during the Rsat configuration

## EXAMPLES

### EXAMPLE 1
```
Get-D365RsatSoapHostname
```

This will get the SOAP hostname from IIS.
It will display the SOAP URL / URI correctly formatted, to be used during the configuration of Rsat.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: RSAT, Certificate, Testing, Regression Suite Automation Test, Regression, Test, Automation.

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
