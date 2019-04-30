---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Remove-D365BroadcastMessageConfig

## SYNOPSIS
Remove broadcast message configuration

## SYNTAX

```
Remove-D365BroadcastMessageConfig [-Name] <String> [-Temporary] [<CommonParameters>]
```

## DESCRIPTION
Remove a broadcast message configuration from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Remove-D365BroadcastMessageConfig -Name "UAT"
```

This will remove the broadcast message configuration name "UAT" from the machine.

## PARAMETERS

### -Name
Name of the broadcast message configuration you want to remove from the configuration store

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
Instruct the cmdlet to only temporarily remove the broadcast message configuration from the configuration store

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
Tags: Servicing, Broadcast, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365BroadcastMessageConfig]()

[Clear-D365ActiveBroadcastMessageConfig]()

[Get-D365ActiveBroadcastMessageConfig]()

[Get-D365BroadcastMessageConfig]()

[Send-D365BroadcastMessage]()

[Set-D365ActiveBroadcastMessageConfig]()

