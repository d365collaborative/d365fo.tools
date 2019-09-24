---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365RunbookId

## SYNOPSIS
Get runbook id

## SYNTAX

```
Get-D365RunbookId [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Get the runbook id from inside a runbook file

## EXAMPLES

### EXAMPLE 1
```
Get-D365RunbookId -Path "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook.xml"
```

This will inspect the Runbook.xml file and output the runbookid from inside the XML document.

### EXAMPLE 2
```
Get-D365Runbook | Get-D365RunbookId
```

This will find all runbook file(s) and have them analyzed by the Get-D365RunbookId cmdlet to output the runbookid(s).

### EXAMPLE 3
```
Get-D365Runbook -Latest | Get-D365RunbookId
```

This will find the latest runbook file and have it analyzed by the Get-D365RunbookId cmdlet to output the runbookid.

## PARAMETERS

### -Path
Path to the runbook file that you want to analyse

Accepts value from pipeline, also by property

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Runbook, Analyze, RunbookId, Runbooks

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
