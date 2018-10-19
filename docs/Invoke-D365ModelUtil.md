---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365ModelUtil

## SYNOPSIS
Invoke the ModelUtil.exe

## SYNTAX

```
Invoke-D365ModelUtil [-Path] <String> [[-BinDir] <String>] [[-MetaDataDir] <String>] [-Import]
 [<CommonParameters>]
```

## DESCRIPTION
A cmdlet that wraps some of the cumbersome work into a streamlined process

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365ModelUtil -Path "c:\temp\d365fo.tools\ApplicationSuiteModernDesigns_App73.axmodel"
```

This will execute the import functionality of ModelUtil.exe and have it import the "ApplicationSuiteModernDesigns_App73.axmodel" file.

## PARAMETERS

### -Path
Path to the model package/file that you want to install into the environment

The cmdlet only supports an already extracted ".axmodel" file

```yaml
Type: String
Parameter Sets: (All)
Aliases: File, Model

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BinDir
The path to the bin directory for the environment

Default path is the same as the AOS service PackagesLocalDirectory\bin

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: "$Script:PackageDirectory\bin"
Accept pipeline input: False
Accept wildcard characters: False
```

### -MetaDataDir
The path to the meta data directory for the environment

Default path is the same as the aos service PackagesLocalDirectory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: "$Script:MetaDataDir"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Import
Switch to instruct the cmdlet to execute the Import functionality on ModelUtil.exe

Default value is: on / $true

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: [switch]::Present
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
