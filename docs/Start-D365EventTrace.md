---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Start-D365EventTrace

## SYNOPSIS
Start an Event Trace session

## SYNTAX

```
Start-D365EventTrace [-ProviderName] <String[]> [[-OutputPath] <String>] [[-SessionName] <String>]
 [[-FileName] <String>] [[-OutputFormat] <String>] [[-MinBuffer] <Int32>] [[-MaxBuffer] <Int32>]
 [[-BufferSizeKB] <Int32>] [[-MaxLogFileSizeMB] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Start an Event Trace session with default values to help you getting started

## EXAMPLES

### EXAMPLE 1
```
Start-D365EventTrace -ProviderName "Microsoft-Dynamics-AX-FormServer","Microsoft-Dynamics-AX-XppRuntime"
```

This will start a new Event Tracing session with the binary circular output format.
It uses "Microsoft-Dynamics-AX-FormServer","Microsoft-Dynamics-AX-XppRuntime" as the providernames.
It uses the default output folder "C:\Temp\d365fo.tools\EventTrace".

It will use the default values for the remaining parameters.

### EXAMPLE 2
```
Start-D365EventTrace -ProviderName "Microsoft-Dynamics-AX-FormServer","Microsoft-Dynamics-AX-XppRuntime" -OutputFormat CSV
```

This will start a new Event Tracing session with the comma separated output format.
It uses "Microsoft-Dynamics-AX-FormServer","Microsoft-Dynamics-AX-XppRuntime" as the providernames.
It uses the default output folder "C:\Temp\d365fo.tools\EventTrace".

It will use the default values for the remaining parameters.

## PARAMETERS

### -ProviderName
Name of the provider(s) you want to have part of your trace

Accepts an array/list of provider names

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -OutputPath
Path to the output folder where you want to store the ETL file that will be generated

Default path is "C:\Temp\d365fo.tools\EventTrace"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Join-Path -Path $Script:DefaultTempPath -ChildPath "EventTrace")
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionName
Name that you want the tracing session to have while running the trace

Default value is "d365fo.tools.trace"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: D365fo.tools.trace
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
Name of the file that you want the trace to write its output to

Default value is "d365fo.tools.trace.etl"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: D365fo.tools.trace.etl
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputFormat
The desired output format of the ETL file being outputted from the tracing session

Default value is "bincirc"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Bincirc
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinBuffer
The minimum buffer size in MB that you want the tracing session to work with

Default value is 10240

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 10240
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxBuffer
The maximum buffer size in MB that you want the tracing session to work with

Default value is 10240

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 10240
Accept pipeline input: False
Accept wildcard characters: False
```

### -BufferSizeKB
The buffer size in KB that you want the tracing session to work with

Default value is 1024

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 1024
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxLogFileSizeMB
The maximum log file size in MB that you want the tracing session to work with

Default value is 4096

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 4096
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: ETL, EventTracing, EventTrace

Author: Mötz Jensen (@Splaxi)

This cmdlet/function was inspired by the work of Michael Stashwick (@D365Stuff)

He blog is located here: https://www.d365stuff.co/

and the blogpost that pointed us in the right direction is located here: https://www.d365stuff.co/trace-batch-jobs-and-more-via-cmd-logman/

## RELATED LINKS
