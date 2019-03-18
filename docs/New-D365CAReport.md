---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# New-D365CAReport

## SYNOPSIS
Generate the Customization's Analysis Report (CAR)

## SYNTAX

```
New-D365CAReport [[-Path] <String>] [[-BinDir] <String>] [[-MetaDataDir] <String>] [-Module] <String>
 [-Model] <String> [[-XmlLog] <String>] [<CommonParameters>]
```

## DESCRIPTION
A cmdlet that wraps some of the cumbersome work into a streamlined process

## EXAMPLES

### EXAMPLE 1
```
New-D365CAReport -Path "c:\temp\CAReport.xlsx" -module "ApplicationSuite" -model "MyOverLayerModel"
```

This will generate a CAR report against MyOverLayerModel in the ApplicationSuite Module, and save the report to "c:\temp\CAReport.xlsx"

## PARAMETERS

### -Path
Full path to CAR file (xlsx-file)

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: False
Position: 2
Default value: (Join-Path $Script:DefaultTempPath "CAReport.xlsx")
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

### -Module
Name of the Module to analyse

```yaml
Type: String
Parameter Sets: (All)
Aliases: Package

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Model
Name of the Model to analyse

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -XmlLog
Path where you want to store the Xml log output generated from the best practice analyser

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: (Join-Path $Script:DefaultTempPath "BPCheckLogcd.xml")
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Tommy Skaue (@Skaue)

## RELATED LINKS
