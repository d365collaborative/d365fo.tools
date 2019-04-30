---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365ActiveBroadcastMessageConfig

## SYNOPSIS
Set the active broadcast message configuration

## SYNTAX

```
Set-D365ActiveBroadcastMessageConfig [-Name] <String> [-Temporary] [<CommonParameters>]
```

## DESCRIPTION
Updates the current active broadcast message configuration with a new one

## EXAMPLES

### EXAMPLE 1
```
Set-D365ActiveBroadcastMessageConfig -Name "UAT"
```

This will set the broadcast message configuration named "UAT" as the active configuration.

## PARAMETERS

### -Name
Name of the broadcast message configuration you want to load into the active broadcast message configuration

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

### -Temporary
Instruct the cmdlet to only temporarily override the persisted settings in the configuration store

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
Tags: Servicing, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365BroadcastMessageConfig]()

[Clear-D365ActiveBroadcastMessageConfig]()

[Get-D365ActiveBroadcastMessageConfig]()

[Get-D365BroadcastMessageConfig]()

[Remove-D365BroadcastMessageConfig]()

[Send-D365BroadcastMessage]()

