---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365UserAuthenticationDetail

## SYNOPSIS
Cmdlet used to get authentication details about a user

## SYNTAX

```
Get-D365UserAuthenticationDetail [-Email] <String> [<CommonParameters>]
```

## DESCRIPTION
The cmdlet will take the e-mail parameter and use it to lookup all the needed details for configuring authentication against Dynamics 365 Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365UserAuthenticationDetail -Email "Claire@contoso.com"
```

This will get all the authentication details for the user account with the email address "Claire@contoso.com"

## PARAMETERS

### -Email
The e-mail address / login name of the user that the cmdlet must gather details about

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: User, Users, Security, Configuration, Authentication

Author : Rasmus Andersen (@ITRasmus)
Author : Mötz Jensen (@splaxi)

## RELATED LINKS
