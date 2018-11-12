---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Test-D365Command

## SYNOPSIS
Validate or show parameter set details with colored output

## SYNTAX

```
Test-D365Command [-CommandText] <String> [-Mode] <String> [-IncludeHelp] [<CommonParameters>]
```

## DESCRIPTION
Analyze a function and it's parameters

The cmdlet / function is capable of validating a string input with function name and parameters

## EXAMPLES

### EXAMPLE 1
```
Test-D365Command -CommandText 'Import-D365Bacpac -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd "XyzXyz" -BacpacFile2 "C:\temp\uat.bacpac"' -Mode "Validate" -IncludeHelp
```

This will validate all the parameters that have been passed to the Import-D365Bacpac cmdlet.
All supplied parameters that matches a parameter will be marked with an asterisk.
Will print the coloring help.

### EXAMPLE 2
```
Test-D365Command -CommandText 'Import-D365Bacpac' -Mode "ShowParameters" -IncludeHelp
```

This will display all the parameter sets and their individual parameters.
Will print the coloring help.

## PARAMETERS

### -CommandText
The string that you want to analyze

If there is parameter value present, you have to use the opposite quote strategy to encapsulate the string correctly

E.g.
for double quotes
-CommandText 'Import-D365Bacpac -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd "XyzXyz" -BacpacFile2 "C:\temp\uat.bacpac"'

E.g.
for single quotes
-CommandText "Import-D365Bacpac -ExportModeTier2 -SqlUser 'sqladmin' -SqlPwd 'XyzXyz' -BacpacFile2 'C:\temp\uat.bacpac'"

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

### -Mode
The operation mode of the cmdlet / function

Valid options are:
- Validate
- ShowParameters

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeHelp
Switch to instruct the cmdlet / function to output a simple guide with the colors in it

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
