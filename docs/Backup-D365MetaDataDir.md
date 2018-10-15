---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Backup-D365MetaDataDir

## SYNOPSIS
Create a backup of the Metadata directory

## SYNTAX

```
Backup-D365MetaDataDir [[-MetaDataDir] <String>] [[-BackupDir] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a backup of all the files and folders from the Metadata directory

## EXAMPLES

### EXAMPLE 1
```
Backup-D365MetaDataDir
```

This will backup the PackagesLocalDirectory and create an PackagesLocalDirectory_backup next to it

## PARAMETERS

### -MetaDataDir
Path to the Metadata directory

Default value is the PackagesLocalDirectory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: "$Script:MetaDataDir"
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackupDir
Path where you want the backup to be place

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: "$($Script:MetaDataDir)_backup"
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
