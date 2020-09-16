---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Clear-D365ActiveBroadcastMessageConfig

## SYNOPSIS
Clear the active broadcast message config

## SYNTAX

```
Clear-D365ActiveBroadcastMessageConfig [-Temporary] [<CommonParameters>]
```

## DESCRIPTION
Clear the active broadcast message config from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Clear-D365ActiveBroadcastMessageConfig
```

This will clear the active broadcast message configuration from the configuration store.

## PARAMETERS

### -Temporary
Instruct the cmdlet to only temporarily clear the active broadcast message configuration in the configuration store

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Servicing, Broadcast, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365BroadcastMessageConfig]()

[Get-D365ActiveBroadcastMessageConfig]()

[Get-D365BroadcastMessageConfig]()

[Remove-D365BroadcastMessageConfig]()

[Send-D365BroadcastMessage]()

[Set-D365ActiveBroadcastMessageConfig]()

