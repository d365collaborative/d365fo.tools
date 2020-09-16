---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Start-D365Environment

## SYNOPSIS
Cmdlet to start the different services in a Dynamics 365 Finance & Operations environment

## SYNTAX

### Default (Default)
```
Start-D365Environment [[-ComputerName] <String[]>] [-All] [-OnlyStartTypeAutomatic] [-ShowOriginalProgress]
 [<CommonParameters>]
```

### Specific
```
Start-D365Environment [[-ComputerName] <String[]>] [-Aos] [-Batch] [-FinancialReporter] [-DMF]
 [-OnlyStartTypeAutomatic] [-ShowOriginalProgress] [<CommonParameters>]
```

## DESCRIPTION
Can start all relevant services that is running in a D365FO environment

## EXAMPLES

### EXAMPLE 1
```
Start-D365Environment
```

This will run the cmdlet with the default parameters.
Default is "-All".
This will start all D365FO services on the machine.

### EXAMPLE 2
```
Start-D365Environment -OnlyStartTypeAutomatic
```

This will start all D365FO services on the machine that are configured for Automatic startup.
It will exclude all services that are either manual or disabled in their startup configuration.

### EXAMPLE 3
```
Start-D365Environment -ShowOriginalProgress
```

This will run the cmdlet with the default parameters.
Default is "-All".
This will start all D365FO services on the machine.
The progress of starting the different services will be written to the console / host.

### EXAMPLE 4
```
Start-D365Environment -All
```

This will start all D365FO services on the machine.

### EXAMPLE 5
```
Start-D365Environment -Aos -Batch
```

This will start the Aos & Batch D365FO services on the machine.

### EXAMPLE 6
```
Start-D365Environment -FinancialReporter -DMF
```

This will start the FinancialReporter and DMF services on the machine.

## PARAMETERS

### -ComputerName
An array of computers that you want to start services on.

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
Set when you want to start all relevant services

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
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Aos
Start the Aos (iis) service

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
Start the batch service

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

### -OnlyStartTypeAutomatic
Instruct the cmdlet to filter out services that are set to manual start or disabled

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

### -ShowOriginalProgress
Instruct the cmdlet to show the standard output in the console

Default is $false which will silence the standard output

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
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
