---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365EnvironmentConfig

## SYNOPSIS
Get environment configs

## SYNTAX

```
Get-D365EnvironmentConfig [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get all environment configuration objects from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365EnvironmentConfig
```

This will show all environment configs

## PARAMETERS

### -Name
The name of the environment you are looking for

Default value is "*" to display all environment configs

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Environment, Url, Config, Configuration, Tfs, Vsts, Sql, SqlUser, SqlPwd

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
