---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365ModuleBuild

## SYNOPSIS
Build a package / module (X++ compile + labels, reports optional)

## SYNTAX

```
Invoke-D365ModuleBuild [-Module] <String> [[-OutputDir] <String>] [[-LogPath] <String>]
 [[-MetaDataDir] <String>] [[-ReferenceDir] <String[]>] [[-BinDir] <String>] [-IncludeReports]
 [-ShowOriginalProgress] [-OutputCommandOnly] [[-Verbosity] <String>] [<CommonParameters>]
```

## DESCRIPTION
Build a package / module using the builtin "xppc.exe" executable to compile source code and "labelc.exe" to compile label files

Specify -IncludeReports to also compile reports using "ReportsC.exe"

Returns a result object per module and writes the compiler errors to the console when a module fails

Exits with a terminating error when any module fails

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365ModuleBuild -Module Essence-Temp
```

This will use the default paths and start the xppc.exe with the needed parameters to compile the Essence-Temp package.
When the X++ compile succeeds it will start the labelc.exe to compile the labels.
The build result is returned as an object.
If the build fails, the compiler errors are written to the console.
The default output from all the different steps will be silenced.

### EXAMPLE 2
```
Invoke-D365ModuleBuild -Module Essence-Temp -IncludeReports -ShowOriginalProgress
```

This will compile X++, labels and reports for the Essence-Temp package.
The output from the different steps will be written to the console / host.

## PARAMETERS

### -Module
The package to build

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
The path to the folder to save assemblies

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
The full path of one or more folders containing all assemblies referenced from X++ code

Accepts multiple folders, one "-referencefolder" argument is passed to the compiler per folder

Default path is the same as the aos service PackagesLocalDirectory

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: @($Script:MetaDataDir)
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

### -IncludeReports
Instruct the cmdlet to also compile the reports of the module using "ReportsC.exe"

Default is $false which will skip the reports compile

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

### -Verbosity
Controls how much output is written to the console

None only outputs when there are errors.
Minimal always returns the result object, with the compiler errors on failure.
Detailed streams the live compiler output.
Default is None

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [PsCustomObject]
## NOTES
Tags: Compile, Model, Servicing, Build, X++

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
