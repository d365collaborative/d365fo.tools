---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Initialize-D365TestAutomationCertificate

## SYNOPSIS
Create and configure test automation certificates

## SYNTAX

```
Initialize-D365TestAutomationCertificate [[-CertificateFileName] <String>] [[-PrivateKeyFileName] <String>]
 [[-Password] <SecureString>] [[-MakeCertExecutable] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new self signed certificate for automated testing and reconfigures the AOS Windows Identity Foundation configuration to trust the certificate

## EXAMPLES

### EXAMPLE 1
```
Initialize-D365TestAutomationCertificate
```

This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates and modify the wif.config of the AOS to include the thumbprint and trust the certificate.

## PARAMETERS

### -CertificateFileName
Filename to be used when exporting the cer file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Join-Path $env:TEMP "TestAuthCert.cer")
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateKeyFileName
Filename to be used when exporting the pfx file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: (Join-Path $env:TEMP "TestAuthCert.pfx")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password that you want to use to protect your certificate with

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (ConvertTo-SecureString -String "Password1" -Force -AsPlainText)
Accept pipeline input: False
Accept wildcard characters: False
```

### -MakeCertExecutable
Path to the "MakeCert.exe" utility that you want to use for the generation process

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: C:\Program Files (x86)\Windows Kits\10\bin\x64\MakeCert.exe
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Kenny Saelen (@kennysaelen)
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
