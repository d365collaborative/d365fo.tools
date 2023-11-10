---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365SDPDetails

## SYNOPSIS
Get details from the Software Deployable Package

## SYNTAX

```
Get-D365SDPDetails [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Details details about the inner modules / packages that a Software Deployable Contains

## EXAMPLES

### EXAMPLE 1
```
Get-D365SDPDetails -Path 'C:\Temp\RV-10.0.36.44.zip'
```

This will display the basic details about the package.
The package is a zip file.

A result set example:

Platform PlatformVersion Modules
-------- --------------- -------
Update55 7.0.6651.92     {@{Name=RapidValue; Version=7.0.6651.92}, @{Name=TCLCommon; Version=7.0.6651.92}, @{Name=TC...

### EXAMPLE 2
```
Get-D365SDPDetails -Path 'C:\Temp\RV-10.0.36.44'
```

This will display the basic details about the package.
The package is extracted to a local folder.

A result set example:

Platform PlatformVersion Modules
-------- --------------- -------
Update55 7.0.6651.92     {@{Name=RapidValue; Version=7.0.6651.92}, @{Name=TCLCommon; Version=7.0.6651.92}, @{Name=TC...

### EXAMPLE 3
```
Get-D365SDPDetails -Path 'C:\Temp\RV-10.0.36.44.zip' | Select-Object -ExpandProperty Modules
```

This will display the module details that are part of the package.
The package is a zip file.

A result set example:

Name       Version
----       -------
RapidValue 7.0.6651.92
TCLCommon  7.0.6651.92
TCLLabel   7.0.6651.92

## PARAMETERS

### -Path
Path to the Software Deployable Package that you want to work against

The cmdlet supports a path to a zip-file or directory with the unpacked content

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
