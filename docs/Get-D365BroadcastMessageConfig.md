---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365BroadcastMessageConfig

## SYNOPSIS
Get broadcast message configs

## SYNTAX

```
Get-D365BroadcastMessageConfig [[-Name] <String>] [-OutputAsHashtable] [<CommonParameters>]
```

## DESCRIPTION
Get all broadcast message configuration objects from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365BroadcastMessageConfig
```

This will display all broadcast message configurations on the machine.

### EXAMPLE 2
```
Get-D365BroadcastMessageConfig -OutputAsHashtable
```

This will display all broadcast message configurations on the machine.
Every object will be output as a hashtable, for you to utilize as parameters for other cmdlets.

### EXAMPLE 3
```
Get-D365BroadcastMessageConfig -Name "UAT"
```

This will display the broadcast message configuration that is saved with the name "UAT" on the machine.

## PARAMETERS

### -Name
The name of the broadcast message configuration you are looking for

Default value is "*" to display all broadcast message configs

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

### -OutputAsHashtable
Instruct the cmdlet to return a hastable object

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

### PSCustomObject
## NOTES
Tags: Servicing, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
