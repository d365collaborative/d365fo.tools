---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365CompilerResult

## SYNOPSIS
Get the compiler outputs presented

## SYNTAX

```
Get-D365CompilerResult [-Path] <String> [-ErrorsOnly] [-OutputTotals] [-OutputAsObjects] [<CommonParameters>]
```

## DESCRIPTION
Get the compiler outputs presented in a structured manner on the screen

It could be a Visual Studio compiler log or it could be a Invoke-D365ModuleCompile log you want analyzed

## EXAMPLES

### EXAMPLE 1
```
Get-D365CompilerResult -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log"
```

This will analyze the compiler log file for warning and errors.

A result set example:

File                                                                                    Warnings Errors
----                                                                                    -------- ------
c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log                                        2      1

### EXAMPLE 2
```
Get-D365CompilerResult -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log" -ErrorsOnly
```

This will analyze the compiler log file for warning and errors, but only output if it has errors.

A result set example:

File                                                                                    Warnings Errors
----                                                                                    -------- ------
c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log                                        2      1

### EXAMPLE 3
```
Get-D365CompilerResult -Path "c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log" -ErrorsOnly -OutputAsObjects
```

This will analyze the compiler log file for warning and errors, but only output if it has errors.
The output will be PSObjects, which can be assigned to a variable and used for futher analysis.

A result set example:

File                                                                                    Warnings Errors
----                                                                                    -------- ------
c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log                                        2      1

### EXAMPLE 4
```
Get-D365Module -Name *Custom* | Invoke-D365ModuleCompile | Get-D365CompilerResult -OutputTotals
```

This will find all modules with Custom in their name.
It will pass thoses modules into the Invoke-D365ModuleCompile, which will compile them.
It will pass the paths to each compile output log to Get-D365CompilerResult, which will analyze them for warning and errors.
It will output the total number of warning and errors found.

File                                                                                    Warnings Errors
----                                                                                    -------- ------
c:\temp\d365fo.tools\Custom\Dynamics.AX.Custom.xppc.log                                        2      1

Total Errors: 1
Total Warnings: 2

## PARAMETERS

### -Path
Path to the compiler log file that you want to work against

A BuildModelResult.log or a Dynamics.AX.*.xppc.log file will both work

```yaml
Type: String
Parameter Sets: (All)
Aliases: LogFile

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ErrorsOnly
Instructs the cmdlet to only output compile results where there was errors detected

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

### -OutputTotals
Instructs the cmdlet to output the total errors and warnings after the analysis

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

### -OutputAsObjects
Instructs the cmdlet to output the objects instead of formatting them

If you don't assign the output, it will be formatted the same way as the original output, but without the coloring of the column values

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
