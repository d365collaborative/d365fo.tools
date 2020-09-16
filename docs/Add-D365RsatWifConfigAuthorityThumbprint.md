---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Add-D365RsatWifConfigAuthorityThumbprint

## SYNOPSIS
Add a certificate thumbprint to the wif.config.

## SYNTAX

```
Add-D365RsatWifConfigAuthorityThumbprint [-CertificateThumbprint] <String> [<CommonParameters>]
```

## DESCRIPTION
Register a certificate thumbprint in the wif.config file.
This can be useful for example when configuring RSAT on a local machine and add the used certificate thumbprint to that AOS.s

## EXAMPLES

### EXAMPLE 1
```
Add-D365RsatWifConfigAuthorityThumbprint -CertificateThumbprint "12312323r424"
```

This will open the wif.config file and insert the "12312323r424" thumbprint value into the file.

## PARAMETERS

### -CertificateThumbprint
The thumbprint value of the certificate that you want to register in the wif.config file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: RSAT, Certificate, Testing, Regression Suite Automation Test, Regression, Test, Automation

Author: Kenny Saelen (@kennysaelen)

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
