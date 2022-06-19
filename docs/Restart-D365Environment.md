---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Restart-D365Environment

## SYNOPSIS
Restart the different services

## SYNTAX

### Default (Default)
```
Restart-D365Environment [[-ComputerName] <String[]>] [-All] [-Kill] [-ShowOriginalProgress]
 [<CommonParameters>]
```

### Specific
```
Restart-D365Environment [[-ComputerName] <String[]>] [-Aos] [-Batch] [-FinancialReporter] [-DMF] [-Kill]
 [-ShowOriginalProgress] [<CommonParameters>]
```

## DESCRIPTION
Restart the different services in a Dynamics 365 Finance & Operations environment

## EXAMPLES

### EXAMPLE 1
```
Restart-D365Environment -All
```

This will stop all services and then start all services again.

### EXAMPLE 2
```
Restart-D365Environment -All -ShowOriginalProgress
```

This will stop all services and then start all services again.
The progress of Stopping the different services will be written to the console / host.
The progress of Starting the different services will be written to the console / host.

### EXAMPLE 3
```
Restart-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1" -All
```

This will work against the machines: "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1".
This will stop all services and then start all services again.

### EXAMPLE 4
```
Restart-D365Environment -Aos -Batch
```

This will stop the AOS and Batch services and then start the AOS and Batch services again.

### EXAMPLE 5
```
Restart-D365Environment -FinancialReporter -DMF
```

This will stop the FinancialReporter and DMF services and then start the FinancialReporter and DMF services again.

### EXAMPLE 6
```
Restart-D365Environment -All -Kill
```

This will stop all services and then start all services again.
It will use the Kill parameter to make sure that the services is stopped.

## PARAMETERS

### -ComputerName
An array of computers that you want to work against

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
Instructs the cmdlet work against all relevant services

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
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Aos
Instructs the cmdlet to work against the AOS (IIS) service

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
Instructs the cmdlet to work against the Batch service

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
Instructs the cmdlet to work against the Financial Reporter (Management Reporter 2012)

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
Instructs the cmdlet to work against the DMF service

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

### -Kill
Instructs the cmdlet to kill the service(s) that you want to restart

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
Tags: Environment, Service, Services, Aos, Batch, Servicing

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
