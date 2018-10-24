---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Environment

## SYNOPSIS
Cmdlet to get the current status for the different services in a Dynamics 365 Finance & Operations environment

## SYNTAX

### Default (Default)
```
Get-D365Environment [[-ComputerName] <String[]>] [-All] [<CommonParameters>]
```

### Specific
```
Get-D365Environment [[-ComputerName] <String[]>] [-Aos] [-Batch] [-FinancialReporter] [-DMF]
 [<CommonParameters>]
```

## DESCRIPTION
List status for all relevant services that is running in a D365FO environment

## EXAMPLES

### EXAMPLE 1
```
Get-D365Environment -All
```

Will query all D365FO service on the machine

### EXAMPLE 2
```
Get-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1" -All
```

Will query all D365FO service on the different machines

### EXAMPLE 3
```
Get-D365Environment -Aos -Batch
```

Will query the Aos & Batch services on the machine

## PARAMETERS

### -ComputerName
An array of computers that you want to query for the services status on.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @($env:computername)
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Set when you want to query all relevant services

Includes:
Aos
Batch
Financial Reporter
DMF

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: 3
Default value: [switch]::Present
Accept pipeline input: False
Accept wildcard characters: False
```

### -Aos
Switch to instruct the cmdlet to query the AOS (IIS) service

```yaml
Type: SwitchParameter
Parameter Sets: Specific
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Batch
Switch to instruct the cmdlet query the batch service

```yaml
Type: SwitchParameter
Parameter Sets: Specific
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FinancialReporter
Switch to instruct the cmdlet query the financial reporter (Management Reporter 2012)

```yaml
Type: SwitchParameter
Parameter Sets: Specific
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DMF
Switch to instruct the cmdlet query the DMF service

```yaml
Type: SwitchParameter
Parameter Sets: Specific
Aliases:

Required: False
Position: 6
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
