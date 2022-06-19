---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Backup-D365DevConfig

## SYNOPSIS
Backup the DynamicsDevConfig.xml file

## SYNTAX

```
Backup-D365DevConfig [[-OutputPath] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Will backup the DynamicsDevConfig.xml file located in the PackagesLocalDirectory\Bin folder

## EXAMPLES

### EXAMPLE 1
```
Backup-D365DevConfig
```

Will locate the DynamicsDevConfig.xml file, and back it up.
It will look for the file in the PackagesLocalDirectory\Bin folder.
E.g.
K:\AosService\PackagesLocalDirectory\Bin\DynamicsDevConfig.xml.
It will save the file to the default location: "C:\Temp\d365fo.tools\DevConfigBackup".

A result set example:

Filename              LastModified         File
--------              ------------         ----
DynamicsDevConfig.xml 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\DevConfigBackup\DynamicsDevConfig.xml

### EXAMPLE 2
```
Backup-D365DevConfig -Force
```

Will locate the DynamicsDevConfig.xml file, back it up, and overwrite if a previous backup file exists.
It will look for the file in the PackagesLocalDirectory\Bin folder.
E.g.
K:\AosService\PackagesLocalDirectory\Bin\DynamicsDevConfig.xml.
It will save the file to the default location: "C:\Temp\d365fo.tools\DevConfigBackup".
It will overwrite any file named DynamicsDevConfig.xml in the destination folder.

A result set example:

Filename              LastModified         File
--------              ------------         ----
DynamicsDevConfig.xml 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\DevConfigBackup\DynamicsDevConfig.xml

## PARAMETERS

### -OutputPath
Path to the folder where you want the DynamicsDevConfig.xml file to be persisted

Default is: "C:\Temp\d365fo.tools\DevConfigBackup"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $(Join-Path $Script:DefaultTempPath "DevConfigBackup")
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
Tags: Web Server, IIS, IIS Express, Development

Author: Sander Holvoet (@smholvoet)

## RELATED LINKS
