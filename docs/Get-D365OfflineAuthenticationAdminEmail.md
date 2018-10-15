---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365OfflineAuthenticationAdminEmail

## SYNOPSIS
Gets the registered offline administrator e-mail configured

## SYNTAX

```
Get-D365OfflineAuthenticationAdminEmail [<CommonParameters>]
```

## DESCRIPTION
Get the registered offline administrator from the "DynamicsDevConfig.xml" file located in the default Package Directory

## EXAMPLES

### EXAMPLE 1
```
Get-D365OfflineAuthenticationAdminEmail
```

Will read the DynamicsDevConfig.xml and display the registered Offline Administrator E-mail address.

## PARAMETERS

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

## RELATED LINKS
