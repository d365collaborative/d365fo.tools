---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365DataFlush

## SYNOPSIS
Invoke the one of the data flush classes

## SYNTAX

```
Invoke-D365DataFlush [[-Url] <String>] [-Class <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Invoke one of the runnable classes that is clearing cache, data or something else

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365DataFlush
```

This will make a call against the default URL for the machine and
have it execute the SysFlushAOD class.

### EXAMPLE 2
```
Invoke-D365DataFlush -Class SysFlushData,SysFlushAod
```

This will make a call against the default URL for the machine and
have it execute the SysFlushData and SysFlushAod classes.

## PARAMETERS

### -Url
URL to the Dynamics 365 instance you want to clear the AOD cache on

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Class
The class that you want to execute.

Default value is "SysFlushAod"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: SysFlushAod
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
