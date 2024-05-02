---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Backup-D365WifConfig

## SYNOPSIS
Backup the wif.config file

## SYNTAX

```
Backup-D365WifConfig [[-OutputPath] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Will backup the wif.config file located in the AOS / IIS folder

## EXAMPLES

### EXAMPLE 1
```
Backup-D365WifConfig
```

Will locate the wif.config file, and back it up.
It will look for the file in the AOS / IIS folder.
E.g.
K:\AosService\WebRoot\wif.config.
It will save the file to the default location: "C:\Temp\d365fo.tools\WifConfigBackup".

A result set example:

Filename   LastModified         File
--------   ------------         ----
wif.config 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\WifConfigBackup\wif.config

### EXAMPLE 2
```
Backup-D365WifConfig -Force
```

Will locate the wif.config file, back it up, and overwrite if a previous backup file exists.
It will look for the file in the AOS / IIS folder.
E.g.
K:\AosService\WebRoot\wif.config.
It will save the file to the default location: "C:\Temp\d365fo.tools\WifConfigBackup".
It will overwrite any file named wif.config in the destination folder.

A result set example:

Filename   LastModified         File
--------   ------------         ----
wif.config 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\WifConfigBackup\wif.config

## PARAMETERS

### -OutputPath
Path to the folder where you want the web.config file to be persisted

Default is: "C:\Temp\d365fo.tools\WifConfigBackup"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $(Join-Path $Script:DefaultTempPath "WifConfigBackup")
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
Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS
