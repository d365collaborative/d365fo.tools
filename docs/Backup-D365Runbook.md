---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Backup-D365Runbook

## SYNOPSIS
Backup a runbook file

## SYNTAX

```
Backup-D365Runbook [-File] <String> [[-DestinationPath] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Backup a runbook file for you to persist it for later analysis

## EXAMPLES

### EXAMPLE 1
```
Backup-D365Runbook -File "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook_20190327.xml"
```

This will backup the "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook_20190327.xml".
The default destination folder is used, "c:\temp\d365fo.tools\runbookbackups\".

### EXAMPLE 2
```
Backup-D365Runbook -File "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook_20190327.xml" -Force
```

This will backup the "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook_20190327.xml".
The default destination folder is used, "c:\temp\d365fo.tools\runbookbackups\".
If the file already exists in the destination folder, it will be overwritten.

### EXAMPLE 3
```
Get-D365Runbook | Backup-D365Runbook
```

This will backup all runbook files found with the "Get-D365Runbook" cmdlet.
The default destination folder is used, "c:\temp\d365fo.tools\runbookbackups\".

## PARAMETERS

### -File
Path to the file you want to backup

```yaml
Type: String
Parameter Sets: (All)
Aliases: Path

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DestinationPath
Path to the folder where you want the backup file to be placed

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $(Join-Path $Script:DefaultTempPath "RunbookBackups")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Instructs the cmdlet to overwrite the destination file if it already exists

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
Tags: Runbook, Backup, Analysis

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
