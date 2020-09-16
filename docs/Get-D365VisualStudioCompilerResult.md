---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365VisualStudioCompilerResult

## SYNOPSIS
Get the compiler outputs presented

## SYNTAX

```
Get-D365VisualStudioCompilerResult [[-Module] <String>] [-ErrorsOnly] [-OutputTotals] [-OutputAsObjects]
 [[-PackageDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get the Visual Studio compiler outputs presented in a structured manner on the screen

## EXAMPLES

### EXAMPLE 1
```
Get-D365VisualStudioCompilerResult
```

This will return the compiler output for all modules.

A result set example:

File                                                                                     Warnings Errors
----                                                                                     -------- ------
K:\AosService\PackagesLocalDirectory\ApplicationCommon\BuildModelResult.log                    55      0
K:\AosService\PackagesLocalDirectory\ApplicationFoundation\BuildModelResult.log               692      0
K:\AosService\PackagesLocalDirectory\ApplicationPlatform\BuildModelResult.log                 155      0
K:\AosService\PackagesLocalDirectory\ApplicationSuite\BuildModelResult.log                  10916      0
K:\AosService\PackagesLocalDirectory\CustomModule\BuildModelResult.log                          1      2

### EXAMPLE 2
```
Get-D365VisualStudioCompilerResult -ErrorsOnly
```

This will return the compiler output for all modules where there was errors in.

A result set example:

File                                                                                     Warnings Errors
----                                                                                     -------- ------
K:\AosService\PackagesLocalDirectory\CustomModule\BuildModelResult.log                          1      2

### EXAMPLE 3
```
Get-D365VisualStudioCompilerResult -ErrorsOnly -OutputAsObjects
```

This will return the compiler output for all modules where there was errors in.
The output will be PSObjects, which can be assigned to a variable and used for futher analysis.

A result set example:

File                                                                                     Warnings Errors
----                                                                                     -------- ------
K:\AosService\PackagesLocalDirectory\CustomModule\BuildModelResult.log                          1      2

### EXAMPLE 4
```
Get-D365VisualStudioCompilerResult -OutputTotals
```

This will return the compiler output for all modules and write a total overview to the console.

A result set example:

File                                                                                     Warnings Errors
----                                                                                     -------- ------
K:\AosService\PackagesLocalDirectory\ApplicationCommon\BuildModelResult.log                    55      0
K:\AosService\PackagesLocalDirectory\ApplicationFoundation\BuildModelResult.log               692      0
K:\AosService\PackagesLocalDirectory\ApplicationPlatform\BuildModelResult.log                 155      0
K:\AosService\PackagesLocalDirectory\ApplicationSuite\BuildModelResult.log                  10916      0
K:\AosService\PackagesLocalDirectory\CustomModule\BuildModelResult.log                          1      2


Total Errors: 2
Total Warnings: 11819

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

### -PackageDirectory
Path to the directory containing the installed package / module

Default path is the same as the AOS service "PackagesLocalDirectory" directory

Default value is fetched from the current configuration on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:PackageDirectory
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
