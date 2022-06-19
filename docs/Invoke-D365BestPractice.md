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
Invoke-D365BestPractice [-Module] <String> [-Model] <String> [[-BinDir] <String>] [[-MetaDataDir] <String>]
 [-PackagesRoot] [[-LogPath] <String>] [-ShowOriginalProgress] [-RunFixers] [-OutputCommandOnly]
 [<CommonParameters>]
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

### EXAMPLE 2
```
Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel" -PackagesRoot
```

This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.
We use the binary metadata to look for the module and model.
The default output will be silenced.
The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".

### EXAMPLE 3
```
Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel" -ShowOriginalProgress
```

This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.
The output from the best practice check process will be written to the console / host.
The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".

### EXAMPLE 4
```
Invoke-D365BestPractice -module "ApplicationSuite" -model "MyOverLayerModel" -RunFixers
```

This will execute the best practice checks against MyOverLayerModel in the ApplicationSuite Module.
The default output will be silenced.
The XML log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.xml".
The log file will be written to "c:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.MyOverLayerModel.xppbp.log".
Instructs the xppbp tool to run the fixers for all identified warnings.

## PARAMETERS

### -Module
Name of the Module to analyse

```yaml
Type: String
Parameter Sets: (All)
Aliases: ModuleName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Model
Name of the Model to analyse

```yaml
Type: String
Parameter Sets: (All)
Aliases: ModelName

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -PackagesRoot
Instructs the cmdlet to use binary metadata

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

### -LogPath
Path where you want to store the log outputs generated from the best practice analyser

Also used as the path where the log file(s) will be saved

When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed

```yaml
Type: String
Parameter Sets: (All)
Aliases: LogDir

Required: False
Position: 5
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\BestPractice")
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
Position: Named
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
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputCommandOnly
Instruct the cmdlet to only output the command that you would have to execute by hand

Will include full path to the executable and the needed parameters based on your selection

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

### [PsCustomObject]
## NOTES
Tags: Best Practice, BP, BPs, Module, Model, Quality

Author: Gert Van Der Heyden (@gertvdheyden)

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
