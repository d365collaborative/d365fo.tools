---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365ReArmWindows

## SYNOPSIS
Invokes the Rearm of Windows license

## SYNTAX

```
Invoke-D365ReArmWindows [-Restart] [<CommonParameters>]
```

## DESCRIPTION
Function used for invoking the rearm functionality inside Windows

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365ReArmWindows
```

This will re arm the Windows installation if there is any activation retries left

### EXAMPLE 2
```
Invoke-D365ReArmWindows -Restart
```

This will re arm the Windows installation if there is any activation retries left and restart the computer.

## PARAMETERS

### -Restart
Instruct the cmdlet to restart the machine

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

## RELATED LINKS
