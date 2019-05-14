---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365RsatCertificateThumbprint

## SYNOPSIS
Get the thumbprint from the RSAT certificate

## SYNTAX

```
Get-D365RsatCertificateThumbprint [<CommonParameters>]
```

## DESCRIPTION
Locate the thumbprint for the certificate created during the RSAT installation

## EXAMPLES

### EXAMPLE 1
```
Get-D365RsatCertificateThumbprint
```

This will locate any certificates that has 127.0.0.1 in its name.
It will show the subject and the thumbprint values.

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
