---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365ModuleFullCompileSync

## SYNOPSIS
Compile and sync a module

## SYNTAX

```
Invoke-D365ModuleFullCompileSync [-ModuleName] <String> [[-OutputDir] <String>] [[-LogDir] <String>]
 [[-MetaDataDir] <String>] [[-ReferenceDir] <String>] [[-BinDir] <String>] [-ShowOriginalProgress]
 [-OutputCommandOnly] [<CommonParameters>]
```

## DESCRIPTION
Compile and sync a package using
    - Invoke-D365ModuleFullCompile function
    - "syncengine.exe" to sync the table and extension elements for module

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365ModuleFullCompileSync -ModuleName MyModel
```

This will use the default paths and start:
    * Invoke-D365ModuleFullCompile with the needed parameters to compile MyModel package.
    * Invoke-D365DBSyncPartial with the needed parameters to sync MyModel table and extesion elements.

The default output from all the different steps will be silenced.

### EXAMPLE 2
```
Invoke-D365ModuleFullCompileSync -ModuleName "Application*Adaptor"
```

Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor". 
 

For every value of the list perform the following:            
    * Invoke-D365ModuleFullCompile with the needed parameters to compile current module value package.
    * Invoke-D365DBSyncPartial with the needed parameters to sync current module value table and extesion elements.
    
The default output from all the different steps will be silenced.

## PARAMETERS

### -ModuleName
Name of the module that you are looking for

Accepts wildcards for searching.
E.g.
-Name "Application*Adaptor"

Default value is "*" which will search for all modules

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
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

### -LogDir
The path to the folder to save logs

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:DefaultTempPath
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
