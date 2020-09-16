---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365SqlPackagePath

## SYNOPSIS
Set the path for SqlPackage.exe

## SYNTAX

```
Set-D365SqlPackagePath [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Update the path where the module will be looking for the SqlPackage.exe executable

## EXAMPLES

### EXAMPLE 1
```
Set-D365SqlPackagePath -Path "C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe"
```

This will update the path for the SqlPackage.exe in the modules configuration

## PARAMETERS

### -Path
Path to the SqlPackage.exe

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
