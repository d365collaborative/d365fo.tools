---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Add-D365ModuleToRemove

## SYNOPSIS
Adds a ModuleToRemove.txt file to a deployable package

## SYNTAX

```
Add-D365ModuleToRemove [-ModuleToRemove] <String> [-DeployablePackage] <String> [-OutputPath <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Modifies an existing deployable package and adds a ModuleToRemove.txt file to it.

## EXAMPLES

### EXAMPLE 1
```
Add-D365ModuleToRemove -ModuleToRemove "C:\temp\ModuleToRemove.txt" -DeployablePackage "C:\temp\DeployablePackage.zip"
```

This will take the "C:\temp\ModuleToRemove.txt" file and add it to the "C:\temp\DeployablePackage.zip" deployable package in the "AOSService/Scripts" folder.

### EXAMPLE 2
```
New-D365ModuleToRemove -Path C:\Temp -Modules "MyRemovedModule1","MySecondRemovedModule" | Add-D365ModuleToRemove -DeployablePackage C:\Temp\DeployablePackage.zip
```

This will create a new ModuleToRemove.txt file and fill in "MyRemovedModule1" and "MySecondRemovedModule" as the modules to remove.
The file is then added to the "C:\Temp\DeployablePackage.zip" deployable package.

## PARAMETERS

### -ModuleToRemove
Path to the ModuleToRemove.txt file that you want to have inside a deployable package

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DeployablePackage
Path to the deployable package file where the ModuleToRemove.txt file should be added

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

### -OutputPath
Path where you want the generated deployable package to be stored

Default value is the same as the "DeployablePackage" parameter

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $DeployablePackage
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

[New-D365ModuleToRemove]()

