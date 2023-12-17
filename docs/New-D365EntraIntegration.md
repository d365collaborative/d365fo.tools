---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# New-D365EntraIntegration

## SYNOPSIS
Enable the Microsoft Entra ID integration on a cloud hosted environment (CHE).

## SYNTAX

### NewCertificate (Default)
```
New-D365EntraIntegration -ClientId <String> [-CertificateName <String>] [-CertificateExpirationYears <Int32>]
 [-NewCertificateFile <String>] [-NewCertificatePrivateKeyFile <String>] [-CertificatePassword <SecureString>]
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ExistingCertificate
```
New-D365EntraIntegration -ClientId <String> -ExistingCertificateFile <String>
 [-ExistingCertificatePrivateKeyFile <String>] [-CertificatePassword <SecureString>] [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Enable the Microsoft Entra ID integration by executing some of the steps described in https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/dev-tools/secure-developer-vm#external-integrations.
The integration can either be enabled with an existing certificate or a new self-signed certificate can be created.
If a new certificate is created and the integration is also to be enabled on other environments with the same certificate, a certificate password must be specified in order to create a certificate private key file.

The steps executed are:
1.
Create a self-signed certificate and save it to Desktop or use a provided certificate.
2.
Install the certificate to the "LocalMachine" certificate store.
3.
Grant NetworkService READ permission to the certificate (only on cloud-hosted environments).
4.
Update the web.config with the application ID and the thumbprint of the certificate.

To execute the steps, the id of an Azure application must be provided.
The application must have the following API permissions:
a.
Dynamics ERP - This permission is required to access finance and operations environments.
b.
Microsoft Graph (User.Read.All and Group.Read.All permissions of the Application type).

The URL of the finance and operations environment must also be added to the RedirectURI in the Authentication section of the Azure application.
Finally, after running the cmdlet, if a new certificate was created, it must be uploaded to the Azure application.

## EXAMPLES

### EXAMPLE 1
```
New-D365EntraIntegration -ClientId e70cac82-6a7c-4f9e-a8b9-e707b961e986
```

Enables the Entra ID integration with a new self-signed certificate named "CHEAuth" which expires after 2 years.

### EXAMPLE 2
```
New-D365EntraIntegration -ClientId e70cac82-6a7c-4f9e-a8b9-e707b961e986 -CertificateName "SelfsignedCert"
```

Enables the Entra ID integration with a new self-signed certificate with the name "Selfsignedcert" that expires after 2 years.

### EXAMPLE 3
```
New-D365EntraIntegration -AppId e70cac82-6a7c-4f9e-a8b9-e707b961e986 -CertificateName "SelfsignedCert" -CertificateExpirationYears 1
```

Enables the Entra ID integration with a new self-signed certificate with the name "SelfsignedCert" that expires after 1 year.

### EXAMPLE 4
```
$securePassword = Read-Host -AsSecureString -Prompt "Enter the certificate password"
```

PS C:\\\> New-D365EntraIntegration -AppId e70cac82-6a7c-4f9e-a8b9-e707b961e986 -CertificatePassword $securePassword

Enables the Entra ID integration with a new self-signed certificate with the name "CHEAuth" that expires after 2 years, using the provided password to generate the private key of the certificate.
The certificate file and the private key file are saved to the Desktop of the current user.

### EXAMPLE 5
```
$securePassword = Read-Host -AsSecureString -Prompt "Enter the certificate password"
```

PS C:\\\> New-D365EntraIntegration -AppId e70cac82-6a7c-4f9e-a8b9-e707b961e986 -ExistingCertificateFile "C:\Temp\SelfsignedCert.cer" -ExistingCertificatePrivateKeyFile "C:\Temp\SelfsignedCert.pfx" -CertificatePassword $securePassword

Enables the Entra ID integration with the certificate file "C:\Temp\SelfsignedCert.cer", the private key file "C:\Temp\SelfsignedCert.pfx" and the provided password to install it.

## PARAMETERS

### -ClientId
The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal.
It is assumed that an application with this id already exists in Azure.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AppId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExistingCertificateFile
The path to a certificate file.
If this parameter is provided, the cmdlet will not create a new certificate.

```yaml
Type: String
Parameter Sets: ExistingCertificate
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExistingCertificatePrivateKeyFile
The path to a certificate private key file.
If this parameter is not provided, the certificate can be installed to the certificate store, but the NetworkService cannot be granted READ permission.

```yaml
Type: String
Parameter Sets: ExistingCertificate
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CertificateName
The name for the certificate.
By default, it is named "CHEAuth".

```yaml
Type: String
Parameter Sets: NewCertificate
Aliases:

Required: False
Position: Named
Default value: CHEAuth
Accept pipeline input: False
Accept wildcard characters: False
```

### -CertificateExpirationYears
The number of years the certificate is valid.
By default, it is valid for 2 years.

```yaml
Type: Int32
Parameter Sets: NewCertificate
Aliases:

Required: False
Position: Named
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewCertificateFile
The path to the certificate file that will be created.
By default, it is created on the Desktop of the current user.

```yaml
Type: String
Parameter Sets: NewCertificate
Aliases:

Required: False
Position: Named
Default value: "$env:USERPROFILE\Desktop\$CertificateName.cer"
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewCertificatePrivateKeyFile
The path to the certificate private key file that will be created.
By default, it is created on the Desktop of the current user.

```yaml
Type: String
Parameter Sets: NewCertificate
Aliases:

Required: False
Position: Named
Default value: "$env:USERPROFILE\Desktop\$CertificateName.pfx"
Accept pipeline input: False
Accept wildcard characters: False
```

### -CertificatePassword
The password for the certificate private key file.
If not provided when creating a new certificate, no private key file will be created.
If not provided when using an existing certificate, the private key file cannot be installed.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Forces the execution of some of the steps.
For example, if a certificate with the same name already exists, it will be deleted and recreated.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### If a new certificate is created, the certificate file is placed on the Desktop of the current user.
### It must be uploaded to the Azure Application.
## NOTES
Author: Øystein Brenna (@oysbre)
Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS
