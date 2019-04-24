---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365ActiveEnvironmentConfig

## SYNOPSIS
Get active environment configuration

## SYNTAX

```
Get-D365ActiveEnvironmentConfig [<CommonParameters>]
```

## DESCRIPTION
Get active environment configuration object from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365ActiveEnvironmentConfig
```

This will get the active environment configuration

### EXAMPLE 2
```
$params = @{}
```

PS C:\\\> $params.SqlUser = (Get-D365ActiveEnvironmentConfig).SqlUser
PS C:\\\> $params.SqlPwd = (Get-D365ActiveEnvironmentConfig).SqlPwd

This gives you a hashtable with the SqlUser and SqlPwd values from the active environment.
This enables you to use the $params as splatting for other cmdlets.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Environment, Url, Config, Configuration, Tfs, Vsts, Sql, SqlUser, SqlPwd

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
