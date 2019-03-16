---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365BestPractice

## SYNOPSIS
Run the Best Practice

## SYNTAX

```
Invoke-D365BestPractice [[-BinDir] <String>] [[-MetaDataDir] <String>] [-Module] <String> [-Model] <String>
 [[-LogDir] <String>] [-PackagesRoot] [-ShowOriginalProgress] [-RunFixers] [<CommonParameters>]
```

## DESCRIPTION
Run the Best Practice checks against modules and models

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel"
```

This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.
The default output will be silenced.
The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".

## PARAMETERS

### -BinDir
The path to the bin directory for the environment

Default path is the same as the AOS service PackagesLocalDirectory\bin

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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
Position: 4
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
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogDir
Path where you want to store the log outputs generated from the best practice analyser

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: (Join-Path $Script:DefaultTempPath $Module)
Accept pipeline input: False
Accept wildcard characters: False
```

### -PackagesRoot
Instructs the cmdlet to use binary metadata

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowOriginalProgress
Instruct the cmdlet to show the standard output in the console

Default is $false which will silence the standard output

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunFixers
Instructs the cmdlet to invoke the fixers for the identified warnings

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [PsCustomObject]
## NOTES
Tags: Best Practice, BP, BPs, Module, Model, Quality

Author: Gert Van Der Heyden (@gertvdheyden)

## RELATED LINKS
