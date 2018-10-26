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
Set-D365ActiveEnvironmentConfig [[-Name] <String>] [[-ConfigStorageLocation] <String>] [-Temporary]
 [<CommonParameters>]
```

## DESCRIPTION
Updates the current active environment configuration with a new one

## EXAMPLES

### EXAMPLE 1
```
Set-D365ActiveEnvironmentConfig -Name "UAT"
```

This will import the "UAT-Exports" set from the Environment configurations.
It will update the active Environment Configuration.

### EXAMPLE 2
```
Set-D365ActiveEnvironmentConfig -Name "UAT" -ConfigStorageLocation "System"
```

This will import the "UAT-Exports" set from the Environment configurations.
It will update the active Environment Configuration.
The data will be stored in the system wide configuration storage, which makes it accessible from all users.

### EXAMPLE 3
```
Set-D365ActiveEnvironmentConfig -Name "UAT" -Temporary
```

This will import the "UAT-Exports" set from the Environment configurations.
It will update the active Environment Configuration.
The update will only last for the rest of this PowerShell console session.

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

### -ConfigStorageLocation
Parameter used to instruct where to store the configuration objects

The default value is "User" and this will store all configuration for the active user

Valid options are:
"User"
"System"

"System" will store the configuration so all users can access the configuration objects

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -Temporary
Switch to instruct the cmdlet to only temporarily override the persisted settings in the configuration storage

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
