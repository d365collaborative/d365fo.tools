---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Clear-D365MonitorData

## SYNOPSIS
Clear the monitoring data from a Dynamics 365 for Finance & Operations machine

## SYNTAX

```
Clear-D365MonitorData [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Clear the monitoring data that is filling up the service drive on a Dynamics 365 for Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Clear-D365MonitorData
```

This will delete all the files that are located in the default path on the machine.
Some files might be locked by a process, but the cmdlet will attemp to delete all files.

## PARAMETERS

### -Path
The path to where the monitoring data is located

The default value is the "ServiceDrive" (j:\ | k:\\) and the \MonAgentData\SingleAgent\Tables folder structure

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Join-Path $script:ServiceDrive "\MonAgentData\SingleAgent\Tables")
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Monitor, MonitorData, MonitorAgent, CleanUp, Servicing

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
