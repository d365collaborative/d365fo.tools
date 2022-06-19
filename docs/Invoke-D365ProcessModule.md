---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365ProcessModule

## SYNOPSIS
Process a specific or multiple modules (compile, deploy reports and sync)

## SYNTAX

```
Invoke-D365ProcessModule [-Module] <String> [-ExecuteCompile] [-ExecuteSync] [-ExecuteDeployReports]
 [[-OutputDir] <String>] [[-LogPath] <String>] [[-MetaDataDir] <String>] [[-ReferenceDir] <String>]
 [[-BinDir] <String>] [-ShowOriginalProgress] [-OutputCommandOnly] [<CommonParameters>]
```

## DESCRIPTION
Process a specific or multiple modules by invoking the following functions (based on flags)
- Invoke-D365ModuleFullCompile function
- Publish-D365SsrsReport to deploy the reports of a module
- Invoke-D365DBSyncPartial to sync the table and extension elements for module

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365ProcessModule -Module "Application*Adaptor" -ExecuteCompile
```

Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".

For every value of the list perform the following:
* Invoke-D365ModuleFullCompile with the needed parameters to compile current module value package.

The default output from all the different steps will be silenced.

### EXAMPLE 2
```
Invoke-D365ProcessModule -Module "Application*Adaptor" -ExecuteSync
```

Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".

For every value of the list perform the following:
* Invoke-D365DBSyncPartial with the needed parameters to sync current module value table and extension elements.

The default output from all the different steps will be silenced.

### EXAMPLE 3
```
Invoke-D365ProcessModule -Module "Application*Adaptor" -ExecuteDeployReports
```

Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".

For every value of the list perform the following:
* Publish-D365SsrsReport with the required parameters to deploy all reports of current module

The default output from all the different steps will be silenced.

### EXAMPLE 4
```
Invoke-D365ProcessModule -Module "Application*Adaptor" -ExecuteCompile -ExecuteSync -ExecuteDeployReports
```

Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".

For every value of the list perform the following:
* Invoke-D365ModuleFullCompile with the needed parameters to compile current module package.
* Invoke-D365DBSyncPartial with the needed parameters to sync current module table and extension elements.
* Publish-D365SsrsReport with the required parameters to deploy all reports of current module

The default output from all the different steps will be silenced.

## PARAMETERS

### -Module
Name of the module that you want to process

Accepts wildcards for searching.
E.g.
-Module "Application*Adaptor"

Default value is "*" which will search for all modules

```yaml
Type: String
Parameter Sets: (All)
Aliases: ModuleName

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExecuteCompile
Switch/flag to determine if the compile function should be executed for requested modules

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

### -ExecuteSync
Switch/flag to determine if the databasesync function should be executed for requested modules

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

### -ExecuteDeployReports
Switch/flag to determine if the deploy reports function should be executed for requested modules

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
The full path of a folder containing all assemblies referenced from X++ code

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
Tags: Compile, Model, Servicing, Database, Synchronization

Author: Jasper Callens - Cegeka

## RELATED LINKS
