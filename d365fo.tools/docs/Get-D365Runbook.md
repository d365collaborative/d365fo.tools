---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Runbook

## SYNOPSIS
Get a Dynamics 365 Runbook

## SYNTAX

```
Get-D365Runbook [[-Path] <String>] [-Name <String>] [-Latest] [<CommonParameters>]
```

## DESCRIPTION
Get the full path and filename of a Dynamics 365 Runbook

## EXAMPLES

### EXAMPLE 1
```
Get-D365Runbook
```

This will list all runbooks that are available in the default location.

### EXAMPLE 2
```
Get-D365Runbook -Latest
```

This will get the latest runbook file from the default InstallationRecords directory on the machine.

### EXAMPLE 3
```
Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer
```

This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.

### EXAMPLE 4
```
Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer | Out-File "C:\Temp\d365fo.tools\runbook-analyze-results.xml"
```

This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
The output will be saved into the "C:\Temp\d365fo.tools\runbook-analyze-results.xml" file.

### EXAMPLE 5
```
Get-D365Runbook | ForEach-Object {$_.File | Copy-Item -Destination c:\temp\d365fo.tools }
```

This will save a copy of all runbooks from the default location and save them to "c:\temp\d365fo.tools"

### EXAMPLE 6
```
notepad.exe (Get-D365Runbook -Latest).File
```

This will find the latest runbook file and open it with notepad.

## PARAMETERS

### -Path
Path to the folder containing the runbook files

The default path is "InstallationRecord" which is normally located on the "C:\DynamicsAX\InstallationRecords"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Join-Path $Script:InstallationRecordsDir "Runbooks")
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
Name of the runbook file that you are looking for

The parameter accepts wildcards.
E.g.
-Name *hotfix-20181024*

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Latest
Switch to instruct the cmdlet to only get the latest runbook file, based on the last written attribute

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Runbook, Servicing, Hotfix, DeployablePackage, Deployable Package, InstallationRecordsDirectory, Installation Records Directory

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
