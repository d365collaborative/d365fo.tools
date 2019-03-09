---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365ModuleLabelGeneration

## SYNOPSIS
Generate labels for a package / module / model

## SYNTAX

```
Invoke-D365ModuleLabelGeneration [-Module] <String> [[-OutputDir] <String>] [[-LogDir] <String>]
 [[-MetaDataDir] <String>] [[-ReferenceDir] <String>] [[-BinDir] <String>] [-ShowOriginalProgress]
 [<CommonParameters>]
```

## DESCRIPTION
Generate labels for a package / module / model using the builtin "labelc.exe"

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365ModuleLabelGeneration -Module MyModel
```

This will use the default paths and start the labelc.exe with the needed parameters to labels from the MyModel package.
The default output from the generation process will be silenced.

If an error should occur, both the standard output and error output will be written to the console / host.

### EXAMPLE 2
```
Invoke-D365ModuleLabelGeneration -Module MyModel -ShowOriginalProgress
```

This will use the default paths and start the labelc.exe with the needed parameters to labels from the MyModel package.
The output from the compile will be written to the console / host.

## PARAMETERS

### -Module
Name of the package that you want to work against

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputDir
The path to the folder to save generated artifacts

```yaml
Type: String
Parameter Sets: (All)
Aliases: Output

Required: False
Position: 3
Default value: (Join-Path $Script:MetaDataDir $Module)
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogDir
The path to the folder to save logs

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (Join-Path $Script:DefaultTempPath $Module)
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
Position: 5
Default value: $Script:MetaDataDir
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceDir
The full path of a folder containing all assemblies referenced from X++ code

Default path is the same as the aos service PackagesLocalDirectory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: $Script:MetaDataDir
Accept pipeline input: False
Accept wildcard characters: False
```

### -BinDir
The path to the bin directory for the environment

Default path is the same as the aos service PackagesLocalDirectory\bin

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Script:BinDirTools
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Compile, Model, Servicing, Label, Labels

Author: Ievgen Miroshnikov (@IevgenMir)

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
