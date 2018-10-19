---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365ActiveEnvironmentConfig

## SYNOPSIS
Set the active environment configuration

## SYNTAX

```
Set-D365ActiveEnvironmentConfig [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates the current active environment configuration with a new one

## EXAMPLES

### EXAMPLE 1
```
Set-D365ActiveEnvironmentConfig -Name "UAT"
```

Will scan the list of environment configurations and select the one that matches the supplied name.
This gets imported into the active environment configuration.

## PARAMETERS

### -Name
The name the environment configuration you want to load into the active environment configuration

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Author: Mötz Jensen (@Splaxi)

You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.

You will have to run the Add-D365EnvironmentConfig cmdlet at least once, before this will be capable of working.

## RELATED LINKS
