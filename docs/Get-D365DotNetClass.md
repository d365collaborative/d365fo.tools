---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365DotNetClass

## SYNOPSIS
Get a .NET class from the Dynamics 365 for Finance and Operations installation

## SYNTAX

```
Get-D365DotNetClass [[-Name] <String>] [[-Assembly] <String>] [[-PackageDirectory] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get a .NET class from an assembly file (dll) from the package directory

## EXAMPLES

### EXAMPLE 1
```
Get-D365DotNetClass -Name "ERText*"
```

Will search across all assembly files (*.dll) that are located in the default package directory after
any class that fits the search "ERText*"

### EXAMPLE 2
```
Get-D365DotNetClass -Name "ERText*" -Assembly "*LocalizationFrameworkForAx.dll*"
```

Will search across all assembly files (*.dll) that are fits the search "*LocalizationFrameworkForAx.dll*",
that are located in the default package directory, after any class that fits the search "ERText*"

### EXAMPLE 3
```
Get-D365DotNetClass -Name "ERText*" | Export-Csv -Path c:\temp\results.txt -Delimiter ";"
```

Will search across all assembly files (*.dll) that are located in the default package directory after
any class that fits the search "ERText*"

The output is saved to a file to make it easier to search inside the result set

## PARAMETERS

### -Name
Name of the .NET class that you are looking for

Accepts wildcards for searching.
E.g.
-Name "ER*Excel*"

Default value is "*" which will search for all classes

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Assembly
Name of the assembly file that you want to search for the .NET class

Accepts wildcards for searching.
E.g.
-Name "*AX*Framework*.dll"

Default value is "*.dll" which will search for assembly files

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *.dll
Accept pipeline input: False
Accept wildcard characters: False
```

### -PackageDirectory
Path to the directory containing the installed packages

Normally it is located under the AOSService directory in "PackagesLocalDirectory"

Default value is fetched from the current configuration on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:PackageDirectory
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: .Net, DotNet, Class, Development

Author: Mötz Jensen (@Splaxi)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
