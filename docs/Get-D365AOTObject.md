---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365AOTObject

## SYNOPSIS
Search for AOT object

## SYNTAX

```
Get-D365AOTObject [-Path] <String> [[-ObjectType] <String[]>] [[-Name] <String>] [-SearchInPackages]
 [-IncludePath] [<CommonParameters>]
```

## DESCRIPTION
Enables you to search for different AOT objects

## EXAMPLES

### EXAMPLE 1
```
Get-D365AOTObject -Name *flush* -ObjectType AxClass -Path "C:\AOSService\PackagesLocalDirectory\ApplicationFoundation"
```

This will search inside the ApplicationFoundation package for all AxClasses that matches the search *flush*.

### EXAMPLE 2
```
Get-D365AOTObject -Name *flush* -ObjectType AxClass -IncludePath -Path "C:\AOSService\PackagesLocalDirectory\ApplicationFoundation"
```

This will search inside the ApplicationFoundation package for all AxClasses that matches the search *flush* and include the full path to the files.

### EXAMPLE 3
```
Get-D365InstalledPackage -Name Application* | Get-D365AOTObject -Name *flush* -ObjectType AxClass
```

This searches for all packages that matches Application* and pipes them into Get-D365AOTObject which will search for all AxClasses that matches the search *flush*.

### EXAMPLE 4
```
Get-D365AOTObject -Path "C:\AOSService\PackagesLocalDirectory\*" -Name *flush* -ObjectType AxClass -SearchInPackages
```

This is an advanced example and shouldn't be something you resolve to every time.

This will search across all packages and will look for the all AxClasses that matches the search *flush*.
It will NOT search in the XppMetaData directory for each package.

This can stress your system.

## PARAMETERS

### -Path
Path to the package that you want to work against

```yaml
Type: String
Parameter Sets: (All)
Aliases: PackageDirectory

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ObjectType
The type of AOT object you're searching for

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Type

Required: False
Position: 2
Default value: @("AxClass")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the object that you're looking for

Accepts wildcards for searching.
E.g.
-Name "Work*status"

Default value is "*" which will search for all objects

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchInPackages
Switch to instruct the cmdlet to search in packages directly instead
of searching in the XppMetaData directory under a given package

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

### -IncludePath
Switch to instruct the cmdlet to include the path for the object found

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
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
