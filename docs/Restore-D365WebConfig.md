---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Restore-D365WebConfig

## SYNOPSIS
Restore the web.config file

## SYNTAX

```
Restore-D365WebConfig [[-Path] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Will restore the web.config file located back into the AOS / IIS folder

## EXAMPLES

### EXAMPLE 1
```
Restore-D365WebConfig -Force
```

Will restore the web.config file, and overwrite the current web.config file in the AOS / IIS folder.
It will use the default path "C:\Temp\d365fo.tools\WebConfigBackup" as the source directory.
It will overwrite the current web.config file.

A result set example:

Filename   LastModified         File
--------   ------------         ----
web.config 6/29/2021 7:31:04 PM K:\AosService\WebRoot\web.config

## PARAMETERS

### -Path
Path to the folder where you the desired web.config file that you want restored is located

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
