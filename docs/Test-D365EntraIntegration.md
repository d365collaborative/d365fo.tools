---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Test-D365EntraIntegration

## SYNOPSIS
Test the Entra Id integration

## SYNTAX

```
Test-D365EntraIntegration
```

## DESCRIPTION
Validates the configuration of the web.config file and the certificate for the environment

If any of the configuration is missing or in someway incorrect, it will prompt and stating corrective actions needed

## EXAMPLES

### EXAMPLE 1
```
Test-D365EntraIntegration
```

This will validate the settings inside the web.config file.
It will search for Aad.Realm, Infrastructure.S2SCertThumbprint, GraphApi.GraphAPIServicePrincipalCert
It will search for the certificate that matches the thumbprint.

A result set example:

EntraAppId                           Thumbprint                               Subject    Expiration
----------                           ----------                               -------    ----------
e068e004-8bec-48c3-a36f-2ab4982ee738 0768175DF3DFDEA3FA78925ADC1E588707649335 CN=CHEAuth 2/5/2026 8:09:28 AM

## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES
Based on: https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/dev-tools/secure-developer-vm#external-integrations

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
