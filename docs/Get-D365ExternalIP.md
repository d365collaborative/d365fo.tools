---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365ExternalIP

## SYNOPSIS
Get the external IP address

## SYNTAX

```
Get-D365ExternalIP [-SaveToClipboard] [<CommonParameters>]
```

## DESCRIPTION
Get the external IP address by calling an external webpage and interpret the result from that

## EXAMPLES

### EXAMPLE 1
```
Get-D365ExternalIP
```

Will call the external page, interpret the output and display it as output.

A result set example:

IpAddress
---------
40.113.130.229

### EXAMPLE 2
```
Get-D365ExternalIP -SaveToClipboard
```

Will call the external page, interpret the output and display it as output.
It will save/copy the IP address into the clipboard.

A result set example:

IpAddress
---------
40.113.130.229

## PARAMETERS

### -SaveToClipboard
Instruct the cmdlet to copy the IP address directly into the clipboard, to save you the trouble

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
Tags: DEV, Tier2, DB, Database, Debug, JIT, LCS, Azure DB, IP

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
