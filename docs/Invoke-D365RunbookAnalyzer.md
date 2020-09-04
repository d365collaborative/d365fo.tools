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

### Default (Default)
```
Invoke-D365RunbookAnalyzer -Path <String> [<CommonParameters>]
```

### FailedOnlyAsObjects
```
Invoke-D365RunbookAnalyzer -Path <String> [-FailedOnlyAsObjects] [<CommonParameters>]
```

### FailedOnly
```
Invoke-D365RunbookAnalyzer -Path <String> [-FailedOnly] [<CommonParameters>]
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
Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer -FailedOnly
```

This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
The output from Invoke-D365RunbookAnalyzer will only contain failed steps.

### EXAMPLE 4
```
Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer -FailedOnlyAsObjects
```

This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
The output from Invoke-D365RunbookAnalyzer will only contain failed steps.
The output will be formatted as PSCustomObjects, to be used as variables or piping.

### EXAMPLE 5
```
Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer -FailedOnlyAsObjects | Get-D365RunbookLogFile -Path "C:\Temp\PU35" -OpenInEditor
```

This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
The output from Invoke-D365RunbookAnalyzer will only contain failed steps.
The Get-D365RunbookLogFile will open all log files for the failed step.

### EXAMPLE 6
```
Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer | Out-File "C:\Temp\d365fo.tools\runbook-analyze-results.xml"
```

This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
The output will be saved into the "C:\Temp\d365fo.tools\runbook-analyze-results.xml" file.

### EXAMPLE 7
```
Get-D365Runbook -Latest | Backup-D365Runbook -Force | Invoke-D365RunbookAnalyzer
```

This will get the latest runbook from the default location.
This will backup the file onto the default "c:\temp\d365fo.tools\runbookbackups\".
This will start the Runbook Analyzer on the backup file.

## PARAMETERS

### -Path
Path to the runbook file that you work against

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -FailedOnly
Instruct the cmdlet to only output failed steps

```yaml
Type: SwitchParameter
Parameter Sets: FailedOnly
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailedOnlyAsObjects
Instruct the cmdlet to only output failed steps as objects

```yaml
Type: SwitchParameter
Parameter Sets: FailedOnlyAsObjects
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

### System.String
## NOTES
Tags: Runbook, Servicing, Hotfix, DeployablePackage, Deployable Package, InstallationRecordsDirectory, Installation Records Directory

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
