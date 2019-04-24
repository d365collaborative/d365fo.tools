---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365OfflineAuthenticationAdminEmail

## SYNOPSIS
Sets the offline administrator e-mail

## SYNTAX

```
Set-D365OfflineAuthenticationAdminEmail [-Email] <String> [<CommonParameters>]
```

## DESCRIPTION
Sets the registered offline administrator in the "DynamicsDevConfig.xml" file located in the default Package Directory

## EXAMPLES

### EXAMPLE 1
```
Set-D365OfflineAuthenticationAdminEmail -Email "admin@contoso.com"
```

Will update the Offline Administrator E-mail address in the DynamicsDevConfig.xml file with "admin@contoso.com"

## PARAMETERS

### -Email
The desired email address of the to be offline administrator

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This cmdlet is inspired by the work of "Sheikh Sohail Hussain" (twitter: @SSohailHussain)

His blog can be found here:
http://d365technext.blogspot.com

The specific blog post that we based this cmdlet on can be found here:
http://d365technext.blogspot.com/2018/07/offline-authentication-admin-email.html

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
