---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365DotNetMethod

## SYNOPSIS
Get a .NET method from the Dynamics 365 for Finance and Operations installation

## SYNTAX

```
Get-D365DotNetMethod [-Assembly] <String> [[-Name] <String>] [[-TypeName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get a .NET method from an assembly file (dll) from the package directory

## EXAMPLES

### EXAMPLE 1
```
Get-D365DotNetMethod -Assembly "C:\AOSService\PackagesLocalDirectory\ElectronicReporting\bin\Microsoft.Dynamics365.LocalizationFrameworkForAx.dll"
```

Will get all methods, across all classes, from the assembly file

### EXAMPLE 2
```
Get-D365DotNetMethod -Assembly "C:\AOSService\PackagesLocalDirectory\ElectronicReporting\bin\Microsoft.Dynamics365.LocalizationFrameworkForAx.dll" -TypeName "ERTextFormatExcelFileComponent"
```

Will get all methods, from the "ERTextFormatExcelFileComponent" class, from the assembly file

### EXAMPLE 3
```
Get-D365DotNetMethod -Assembly "C:\AOSService\PackagesLocalDirectory\ElectronicReporting\bin\Microsoft.Dynamics365.LocalizationFrameworkForAx.dll" -TypeName "ERTextFormatExcelFileComponent" -Name "*parm*"
```

Will get all methods that fits the search "*parm*", from the "ERTextFormatExcelFileComponent" class, from the assembly file

### EXAMPLE 4
```
Get-D365DotNetClass -Name "ERTextFormatExcelFileComponent" -Assembly "*LocalizationFrameworkForAx.dll*" | Get-D365DotNetMethod
```

Will get all methods, from the "ERTextFormatExcelFileComponent" class, from any assembly file that fits the search "*LocalizationFrameworkForAx.dll*"

## PARAMETERS

### -Assembly
Name of the assembly file that you want to search for the .NET method

Provide the full path for the assembly file you want to work against

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the .NET method that you are looking for

Accepts wildcards for searching.
E.g.
-Name "parmER*Excel*"

Default value is "*" which will search for all methods

```yaml
Type: String
Parameter Sets: (All)
Aliases: MethodName

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName
Name of the .NET class that you want to work against

Accepts wildcards for searching.
E.g.
-Name "*ER*Excel*"

Default value is "*" which will work against all classes

```yaml
Type: String
Parameter Sets: (All)
Aliases: ClassName

Required: False
Position: 4
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: .Net, DotNet, Class, Method, Methods, Development

Author: Mötz Jensen (@Splaxi)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
