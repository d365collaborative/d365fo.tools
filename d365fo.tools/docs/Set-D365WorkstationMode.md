---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365WorkstationMode

## SYNOPSIS
Set the Workstation mode

## SYNTAX

```
Set-D365WorkstationMode [-Enabled] <Boolean> [<CommonParameters>]
```

## DESCRIPTION
Set the Workstation mode to enabled or not

It is used to enable the tool to run on a personal machine and still be able to call Invoke-D365TableBrowser and Invoke-D365SysRunnerClass

## EXAMPLES

### EXAMPLE 1
```
Set-D365WorkstationMode -Enabled $true
```

This will enable the Workstation mode.
You will have to restart the powershell session when you switch around.

## PARAMETERS

### -Enabled
$True enables the workstation mode while $false deactivated the workstation mode

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

## RELATED LINKS
