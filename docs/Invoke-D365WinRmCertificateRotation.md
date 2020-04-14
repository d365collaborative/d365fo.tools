---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365WinRmCertificateRotation

## SYNOPSIS
Rotate the certificate used for WinRM

## SYNTAX

```
Invoke-D365WinRmCertificateRotation [[-MachineName] <String>] [<CommonParameters>]
```

## DESCRIPTION
There is a scenario where you might need to update the certificate that is being used for WinRM on your Tier1 environment

1 year after you deploy your Tier1 environment, the original WinRM certificate expires and then LCS will be unable to communicate with your Tier1 environment

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365WinRmCertificateRotation
```

This will update the certificate that is being used by WinRM.
A new certificate is created with the current computer name.
The new certificate and its thumbprint will be configured for WinRM to use that going forward.

## PARAMETERS

### -MachineName
The DNS / Netbios name of the machine

The default value is: "$env:COMPUTERNAME" which translates into the current name of the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $env:COMPUTERNAME
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

We recommend that you do a full restart of the Tier1 environment when done.

## RELATED LINKS
