---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Backup-D365WebConfig

## SYNOPSIS
Backup the web.config file

## SYNTAX

```
Backup-D365WebConfig [[-OutputPath] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Will backup the web.config file located in the AOS / IIS folder

## EXAMPLES

### EXAMPLE 1
```
Backup-D365WebConfig
```

Will locate the web.config file, and back it up.
It will look for the file in the AOS / IIS folder.
E.g.
K:\AosService\WebRoot\web.config.
It will save the file to the default location: "C:\Temp\d365fo.tools\WebConfigBackup".

A result set example:

Filename   LastModified         File
--------   ------------         ----
web.config 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\WebConfigBackup\web.config

### EXAMPLE 2
```
Backup-D365WebConfig -Force
```

Will locate the web.config file, back it up, and overwrite if a previous backup file exists.
It will look for the file in the AOS / IIS folder.
E.g.
K:\AosService\WebRoot\web.config.
It will save the file to the default location: "C:\Temp\d365fo.tools\WebConfigBackup".
It will overwrite any file named web.config in the destination folder.

A result set example:

Filename   LastModified         File
--------   ------------         ----
web.config 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\WebConfigBackup\web.config

## PARAMETERS

### -OutputPath
Path to the folder where you want the web.config file to be persisted

Default is: "C:\Temp\d365fo.tools\WebConfigBackup"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $(Join-Path $Script:DefaultTempPath "WebConfigBackup")
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
Tags: DEV, Tier2, DB, Database, Debug, JIT, LCS, Azure DB

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
