---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# New-D365ModuleToRemove

## SYNOPSIS
Create a new ModuleToRemove.txt file

## SYNTAX

```
New-D365ModuleToRemove [-Path] <String> [-Modules] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Create a new ModuleToRemove.txt file based on a list of module names

## EXAMPLES

### EXAMPLE 1
```
New-D365ModuleToRemove -Path C:\Temp -Modules "MyRemovedModule1","MySecondRemovedModule"
```

This will create a new ModuleToRemove.txt file and fill in "MyRemovedModule1" and "MySecondRemovedModule" as the modules to remove.
The new file is stored at "C:\Temp\ModuleToRemove.txt"

## PARAMETERS

### -Path
Path to the ModuleToRemove.txt file

```yaml
Type: String
Parameter Sets: (All)
Aliases: Folder

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Modules
The array with all the module names that you want to fill into the ModuleToRemove.txt file

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS
