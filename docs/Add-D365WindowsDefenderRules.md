---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Add-D365WindowsDefenderRules

## SYNOPSIS
Add rules to Windows Defender to enhance performance during development.

## SYNTAX

```
Add-D365WindowsDefenderRules [-Silent] [<CommonParameters>]
```

## DESCRIPTION
Add rules to the Windows Defender to exclude Visual Studio, D365 Batch process, D365 Sync process, XPP related processes and SQL Server processes from scans and monitoring.
This will lead to performance gains because the Windows Defender stops to scan every file accessed by e.g.
the MSBuild process, the cache and things around Visual Studio.
Supports rules for VS 2015 and VS 2019.

## EXAMPLES

### EXAMPLE 1
```
Add-D365WindowsDefenderRules
```

This will add the most common rules to the Windows Defender as exceptions.
All output will be written to the console.

### EXAMPLE 2
```
Add-D365WindowsDefenderRules -Silent
```

This will add the most common rules to the Windows Defender as exceptions.
All output will be silenced and not outputted to the console.

## PARAMETERS

### -Silent
Instruct the cmdlet to silence the output written to the console

If set the output will be silenced, if not set, the output will be written to the console

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
Tags: DevTools, Developer, Performance

Author: Robin Kretzschmar (@darksmile92)

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
