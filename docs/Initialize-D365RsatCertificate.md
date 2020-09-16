---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Initialize-D365RsatCertificate

## SYNOPSIS
Create and configure test automation certificate

## SYNTAX

```
Initialize-D365RsatCertificate [-CertificateFileName <String>] [-PrivateKeyFileName <String>]
 [-Password <SecureString>] [-CertificateOnly] [-KeepCertificateFile] [-OutputPath <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new self signed certificate for automated testing and reconfigures the AOS Windows Identity Foundation configuration to trust the certificate

## EXAMPLES

### EXAMPLE 1
```
Initialize-D365RsatCertificate
```

This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates and modify the wif.config of the AOS to include the thumbprint and trust the certificate.

### EXAMPLE 2
```
Initialize-D365RsatCertificate -CertificateOnly
```

This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates.
No actions will be taken regarding modifying the AOS wif.config file.

Use this when installing RSAT on a machine different from the AOS where RSAT is pointing to.

### EXAMPLE 3
```
Initialize-D365RsatCertificate -CertificateOnly -KeepCertificateFile
```

This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates.
No actions will be taken regarding modifying the AOS wif.config file.
The pfx will be copied into the default "c:\temp\d365fo.tools" folder after creation.

Use this when installing RSAT on a machine different from the AOS where RSAT is pointing to.

The pfx file enables you to import the same certificate across your entire network, instead of creating one per machine.

## PARAMETERS

### -CertificateFileName
Filename to be used when exporting the cer file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
Default value: (Join-Path $env:TEMP "TestAuthCert.pfx")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password that you want to use to protect your certificate with

The default value is: "Password1"

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (ConvertTo-SecureString -String "Password1" -Force -AsPlainText)
Accept pipeline input: False
Accept wildcard characters: False
```

### -CertificateOnly
Switch specifying if only the certificate needs to be created

If specified, then only the certificate is created and the thumbprint is not added to the wif.config on the AOS side
If not specified (default) then the certificate is created and installed and the corresponding thumbprint is added to the wif.config on the local machine

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

### -KeepCertificateFile
Instruct the cmdlet to copy the certificate file from the working directory into the desired location specified with OutputPath parameter

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

### -OutputPath
Path to where you want the certificate file exported to, when using the KeepCertificateFile parameter switch

Default value is: "c:\temp\d365fo.tools"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:DefaultTempPath
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Automated Test, Test, Regression, Certificate, Thumbprint

Author: Kenny Saelen (@kennysaelen)

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
