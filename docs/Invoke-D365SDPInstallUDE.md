---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365SDPInstallUDE

## SYNOPSIS
Install a Software Deployable Package (SDP) in a unified development environment

## SYNTAX

```
Invoke-D365SDPInstallUDE [-Path] <String> [-MetaDataDir] <String> [-LogPath <String>] [<CommonParameters>]
```

## DESCRIPTION
A cmdlet that wraps some of the cumbersome work into a streamlined process.
It first checks if the package is a zip file and extracts it if necessary.
Then it checks if the package contains the necessary files and modules.
Finally, it extracts the module zip files into the metadata directory.

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SDPInstallUDE -Path "c:\temp\package.zip" -MetaDataDir "c:\MyRepository\Metadata"
```

This will install the modules contained in the c:\temp\package.zip file into the c:\MyRepository\Metadata directory.

## PARAMETERS

### -Path
Path to the package that you want to install into the environment

The cmdlet supports a path to a zip-file or directory with the unpacked contents.

```yaml
Type: String
Parameter Sets: (All)
Aliases: File, Hotfix

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MetaDataDir
The path to the meta data directory for the environment

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogPath
The path where the log file(s) will be saved

```yaml
Type: String
Parameter Sets: (All)
Aliases: LogDir

Required: False
Position: Named
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\SdpInstall")
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
