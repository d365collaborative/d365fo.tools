---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Import-D365Model

## SYNOPSIS
Import a model into Dynamics 365 for Finance & Operations

## SYNTAX

```
Import-D365Model [-Path] <String> [[-BinDir] <String>] [[-MetaDataDir] <String>] [-Replace] [-LogPath <String>]
 [-ShowOriginalProgress] [-OutputCommandOnly] [<CommonParameters>]
```

## DESCRIPTION
Import a model into a Dynamics 365 for Finance & Operations environment

## EXAMPLES

### EXAMPLE 1
```
Import-D365Model -Path c:\temp\d365fo.tools\CustomModel.axmodel
```

This will import the "c:\temp\d365fo.tools\CustomModel.axmodel" model into the PackagesLocalDirectory location.

### EXAMPLE 2
```
Import-D365Model -Path c:\temp\d365fo.tools\CustomModel.axmodel -Replace
```

This will import the "c:\temp\d365fo.tools\CustomModel.axmodel" model into the PackagesLocalDirectory location.
If the model already exists it will replace it.

## PARAMETERS

### -Path
Path to the axmodel file that you want to import

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BinDir
The path to the bin directory for the environment

Default path is the same as the AOS service PackagesLocalDirectory\bin

Default value is fetched from the current configuration on the machine

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

### -Replace
Instruct the cmdlet to replace an already existing model

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
The path where the log file(s) will be saved

When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed

```yaml
Type: String
Parameter Sets: (All)
Aliases: LogDir

Required: False
Position: Named
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\ModelUtilImport")
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

## NOTES
Tags: ModelUtil, Axmodel, Model, Import, Replace, Source Control, Vsts, Azure DevOps

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
