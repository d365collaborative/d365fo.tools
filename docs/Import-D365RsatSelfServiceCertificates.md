---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Import-D365RsatSelfServiceCertificates

## SYNOPSIS
Import certificates for RSAT

## SYNTAX

```
Import-D365RsatSelfServiceCertificates [-Path] <String> [-Password] <String> [<CommonParameters>]
```

## DESCRIPTION
Import the certificates for RSAT into the correct stores and display the thumbprint

When working with self-service environments you need to download a zip file from LCS.
The zip file needs to be unblocked and then extracted into a folder, with only the .cer and the .pxf files inside

## EXAMPLES

### EXAMPLE 1
```
Import-D365RsatSelfServiceCertificates -Path "C:\Temp\UAT" -Password "123456789"
```

This will import the .cer and .pxf files into the correct store, bases on the files located in "C:\Temp\UAT".
After import it will display the thumbprint for both certificates.

Sample output:
\[23:43:05\]\[Import-D365RsatSelfServiceCertificates\] Pfx Thumbprint:  B4D6921321434235463463414312343253523A05
\[23:43:05\]\[Import-D365RsatSelfServiceCertificates\] Cert Thumbprint: B4D6921321434235463463414312343253523A05

## PARAMETERS

### -Path
Path to the folder where the .cer and .pxf files are located

The files needs to be extracted from the zip archive

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Password
Password for the .pxf file

Working with self-service environments, the password will be displayed during the download of the zip archive

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
