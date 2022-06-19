---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365VisualStudioCompilerResultAnalyzer

## SYNOPSIS
Analyze the Visual Studio compiler output log

## SYNTAX

```
Invoke-D365VisualStudioCompilerResultAnalyzer [[-Module] <String>] [[-OutputPath] <String>] [-SkipWarnings]
 [-SkipTasks] [[-PackageDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION
Analyze the Visual Studio compiler output log and generate an excel file contain worksheets per type: Errors, Warnings, Tasks

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365VisualStudioCompilerResultAnalyzer
```

This will analyse all compiler output log files generated from Visual Studio.

A result set example:

File                                                            Filename
----                                                            --------
c:\temp\d365fo.tools\ApplicationCommon-CompilerResults.xlsx     ApplicationCommon-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationFoundation-CompilerResults.xlsx ApplicationFoundation-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationPlatform-CompilerResults.xlsx   ApplicationPlatform-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationSuite-CompilerResults.xlsx      ApplicationSuite-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationWorkspaces-CompilerResults.xlsx ApplicationWorkspaces-CompilerResults.xlsx

### EXAMPLE 2
```
Invoke-D365VisualStudioCompilerResultAnalyzer -SkipWarnings
```

This will analyse all compiler output log files generated from Visual Studio.
It will exclude all warnings from the output.

A result set example:

File                                                            Filename
----                                                            --------
c:\temp\d365fo.tools\ApplicationCommon-CompilerResults.xlsx     ApplicationCommon-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationFoundation-CompilerResults.xlsx ApplicationFoundation-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationPlatform-CompilerResults.xlsx   ApplicationPlatform-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationSuite-CompilerResults.xlsx      ApplicationSuite-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationWorkspaces-CompilerResults.xlsx ApplicationWorkspaces-CompilerResults.xlsx

### EXAMPLE 3
```
Invoke-D365VisualStudioCompilerResultAnalyzer -SkipTasks
```

This will analyse all compiler output log files generated from Visual Studio.
It will exclude all tasks from the output.

A result set example:

File                                                            Filename
----                                                            --------
c:\temp\d365fo.tools\ApplicationCommon-CompilerResults.xlsx     ApplicationCommon-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationFoundation-CompilerResults.xlsx ApplicationFoundation-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationPlatform-CompilerResults.xlsx   ApplicationPlatform-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationSuite-CompilerResults.xlsx      ApplicationSuite-CompilerResults.xlsx
c:\temp\d365fo.tools\ApplicationWorkspaces-CompilerResults.xlsx ApplicationWorkspaces-CompilerResults.xlsx

## PARAMETERS

### -Module
Name of the module that you want to work against

Default value is "*" which will search for all modules

```yaml
Type: String
Parameter Sets: (All)
Aliases: ModuleName

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Path where you want the excel file (xlsx-file) saved to

Default value is: "c:\temp\d365fo.tools\"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:DefaultTempPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipWarnings
Instructs the cmdlet to skip warnings while analyzing the compiler output log file

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

### -SkipTasks
Instructs the cmdlet to skip tasks while analyzing the compiler output log file

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

### -PackageDirectory
Path to the directory containing the installed package / module

Default path is the same as the AOS service "PackagesLocalDirectory" directory

Default value is fetched from the current configuration on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:PackageDirectory
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Compiler, Build, Errors, Warnings, Tasks

Author: Mötz Jensen (@Splaxi)

This cmdlet is inspired by the work of "Vilmos Kintera" (twitter: @DAXRunBase)

All credits goes to him for showing how to extract these information

His blog can be found here:
https://www.daxrunbase.com/blog/

The specific blog post that we based this cmdlet on can be found here:
https://www.daxrunbase.com/2020/03/31/interpreting-compiler-results-in-d365fo-using-powershell/

The github repository containing the original scrips can be found here:
https://github.com/DAXRunBase/PowerShell-and-Azure

## RELATED LINKS
