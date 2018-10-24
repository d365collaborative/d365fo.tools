---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Stop-D365Environment

## SYNOPSIS
Cmdlet to stop the different services in a Dynamics 365 Finance & Operations environment

## SYNTAX

### Default (Default)
```
Stop-D365Environment [[-ComputerName] <String[]>] [-All] [<CommonParameters>]
```

### Specific
```
Stop-D365Environment [[-ComputerName] <String[]>] [-Aos] [-Batch] [-FinancialReporter] [-DMF]
 [<CommonParameters>]
```

## DESCRIPTION
Can stop all relevant services that is running in a D365FO environment

## EXAMPLES

### EXAMPLE 1
```
Stop-D365Environment -All
```

Will stop all D365FO service on the machine

### EXAMPLE 2
```
Stop-D365Environment -Aos -Batch
```

Will stop Aos & Batch services on the machine

## PARAMETERS

### -ComputerName
An array of computers that you want to stop services on.

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
Set when you want to stop all relevant services

Includes:
Aos
Batch
Financial Reporter

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
Stop the Aos (iis) service

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
Stop the batch service

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
Start the financial reporter (Management Reporter 2012) service

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
Start the Data Management Framework service

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
