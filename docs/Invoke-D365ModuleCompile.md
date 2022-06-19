---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365ModuleCompile

## SYNOPSIS
Compile a package / module / model

## SYNTAX

```
Invoke-D365ModuleCompile [-Module] <String> [[-OutputDir] <String>] [[-LogPath] <String>]
 [[-MetaDataDir] <String>] [[-ReferenceDir] <String>] [[-BinDir] <String>] [-XRefGeneration]
 [-ShowOriginalProgress] [-OutputCommandOnly] [<CommonParameters>]
```

## DESCRIPTION
Compile a package / module / model using the builtin "xppc.exe" executable to compile source code

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365ModuleCompile -Module MyModel
```

This will use the default paths and start the xppc.exe with the needed parameters to compile MyModel package.
The default output from the compile will be silenced.

If an error should occur, both the standard output and error output will be written to the console / host.

### EXAMPLE 2
```
Invoke-D365ModuleCompile -Module MyModel -ShowOriginalProgress
```

This will use the default paths and start the xppc.exe with the needed parameters to compile MyModel package.
The output from the compile will be written to the console / host.

### EXAMPLE 3
```
Invoke-D365ModuleCompile -Module MyModel -XRefGeneration
```

This will use the default paths and start the xppc.exe with the needed parameters to compile MyModel package.
The default output from the compile will be silenced.
The compiler will generate XRef metadata while compiling.

If an error should occur, both the standard output and error output will be written to the console / host.

## PARAMETERS

### -Module
The package to compile

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

### -OutputDir
The path to the folder to save generated artifacts

```yaml
Type: String
Parameter Sets: (All)
Aliases: Output

Required: False
Position: 2
Default value: $Script:MetaDataDir
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogPath
Path where you want to store the log outputs generated from the compiler

Also used as the path where the log file(s) will be saved

When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed

```yaml
Type: String
Parameter Sets: (All)
Aliases: LogDir

Required: False
Position: 3
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\ModuleCompile")
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
Position: 5
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
Position: 6
Default value: $Script:BinDirTools
Accept pipeline input: False
Accept wildcard characters: False
```

### -XRefGeneration
Instruct the cmdlet to enable the generation of XRef metadata while running the compile

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

### [PsCustomObject]
## NOTES
Tags: Compile, Model, Servicing, X++

Author: Ievgen Miroshnikov (@IevgenMir)

Author: Mötz Jensen (@Splaxi)

Author: Frank Hüther (@FrankHuether)

## RELATED LINKS
