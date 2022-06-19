---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Restore-D365DevConfig

## SYNOPSIS
Restore the DynamicsDevConfig.xml file

## SYNTAX

```
Restore-D365DevConfig [[-Path] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Will restore the DynamicsDevConfig.xml file located in the PackagesLocalDirectory\Bin folder

## EXAMPLES

### EXAMPLE 1
```
Restore-D365DevConfig -Force
```

Will restore the DynamicsDevConfig.xml file, and overwrite the current DynamicsDevConfig.xml file in the PackagesLocalDirectory\Bin folder.
It will use the default path "C:\Temp\d365fo.tools\DevConfigBackup" as the source directory.
It will overwrite the current DynamicsDevConfig.xml file.

A result set example:

Filename              LastModified         File
--------              ------------         ----
DynamicsDevConfig.xml 6/29/2021 7:31:04 PM K:\AosService\PackagesLocalDirectory\Bin\DynamicsDevConfig.xml

## PARAMETERS

### -Path
Path to the folder where you the desired DynamicsDevConfig.xml file that you want restored is located

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
