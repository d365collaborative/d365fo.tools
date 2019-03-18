---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365SysFlushAodCache

## SYNOPSIS
Invoke the SysFlushAos class

## SYNTAX

```
Invoke-D365SysFlushAodCache [[-Url] <String>] [<CommonParameters>]
```

## DESCRIPTION
Invoke the runnable class SysFlushAos to clear the AOD cache

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SysFlushAodCache
```

This will a call against the default URL for the machine and
have it execute the SysFlushAOD class

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
