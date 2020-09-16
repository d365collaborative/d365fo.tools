---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365RunbookLogFile

## SYNOPSIS
Get log file from a Runbook step

## SYNTAX

```
Get-D365RunbookLogFile [-Path] <String> [-Step] <String> [-Latest] [-OpenInEditor] [<CommonParameters>]
```

## DESCRIPTION
Get the log files for a specific Runbook step

## EXAMPLES

### EXAMPLE 1
```
Get-D365RunbookLogFile -Path "C:\Temp\PU35" -Step 34
```

This will locate all logfiles that has been outputted from the Step 34 from the PU35 installation.
The output will list the complete path to the log files.

An output example:

Filename     : AutoUpdateDIXFService.ps1-2020-07-8--12-40-34.log
LastModified : 8/7/2020 12:40:34 PM
File         : C:\Temp\PU35\RunbookWorkingFolder\Runbook\MININT-F36S5EH\DIXFService\34\Log\AutoUpdateDIXFService.ps1-2020-07-8--12-40-34.log

Filename     : AutoUpdateDIXFService.ps1-2020-07-8--12-36-22.log
LastModified : 8/7/2020 12:36:22 PM
File         : C:\Temp\PU35\RunbookWorkingFolder\Runbook\MININT-F36S5EH\DIXFService\34\Log\AutoUpdateDIXFService.ps1-2020-07-8--12-36-22.log

Filename     : AutoUpdateDIXFService.ps1-2020-05-8--19-15-07.log
LastModified : 8/5/2020 7:15:07 PM
File         : C:\Temp\PU35\RunbookWorkingFolder\Runbook\MININT-F36S5EH\DIXFService\34\Log\AutoUpdateDIXFService.ps1-2020-05-8--19-15-07.log

### EXAMPLE 2
```
Get-D365RunbookLogFile -Path "C:\Temp\PU35" -Step 34 -Latest
```

This will locate all logfiles that has been outputted from the Step 34 from the PU35 installation.
The output will be limited to the latest log, based on last write time.
The output will list the complete path to the log file.

An output example:

Filename     : AutoUpdateDIXFService.ps1-2020-07-8--12-40-34.log
LastModified : 8/7/2020 12:40:34 PM
File         : C:\Temp\PU35\RunbookWorkingFolder\Runbook\MININT-F36S5EH\DIXFService\34\Log\AutoUpdateDIXFService.ps1-2020-07-8--12-40-34.log

### EXAMPLE 3
```
Get-D365RunbookLogFile -Path "C:\Temp\PU35" -Step 34 -OpenInEditor
```

This will locate all logfiles that has been outputted from the Step 34 from the PU35 installation.
The Get-D365RunbookLogFile will open all log files in the default text editor.

### EXAMPLE 4
```
Get-D365RunbookLogFile -Path "C:\Temp\PU35" -Step 34 -Latest -OpenInEditor
```

This will locate all logfiles that has been outputted from the Step 34 from the PU35 installation.
The output will be limited to the latest log, based on last write time.
The Get-D365RunbookLogFile will open the log file in the default text editor.

### EXAMPLE 5
```
Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer -FailedOnlyAsObjects | Get-D365RunbookLogFile -Path "C:\Temp\PU35" -OpenInEditor
```

This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
The output from Invoke-D365RunbookAnalyzer will only contain failed steps.
The Get-D365RunbookLogFile will open all log files for the failed step.

## PARAMETERS

### -Path
Path to Software Deployable Package that was run in connection with the runbook

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Step
Step id for the step that you want to locate the log files for

```yaml
Type: String
Parameter Sets: (All)
Aliases: StepId

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Latest
Instruct the cmdlet to only work with the latest log file

Is based on the last written attribute on the log file

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

### -OpenInEditor
Instruct the cmdlet to open the log file in the default text editor

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

### System.String
## NOTES
Tags: Runbook, Servicing, Hotfix, DeployablePackage, Deployable Package, InstallationRecordsDirectory, Installation Records Directory

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
