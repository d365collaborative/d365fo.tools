---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365RunbookAnalyzer

## SYNOPSIS
Analyze the runbook

## SYNTAX

```
Invoke-D365RunbookAnalyzer [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Get all the important details from a failed runbook

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365RunbookAnalyzer -Path "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook.xml"
```

This will analyze the Runbook.xml and output all the details about failed steps, the connected error logs and all the unprocessed steps.

### EXAMPLE 2
```
Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer
```

This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.

### EXAMPLE 3
```
Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer | Out-File "C:\Temp\d365fo.tools\runbook-analyze-results.xml"
```

This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
The output will be saved into the "C:\Temp\d365fo.tools\runbook-analyze-results.xml" file.

## PARAMETERS

### -Path
Path to the runbook file that you work against

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
