---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365AzCopyPath

## SYNOPSIS
Set the path for AzCopy.exe

## SYNTAX

```
Set-D365AzCopyPath [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Update the path where the module will be looking for the AzCopy.exe executable

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365InstallAzCopy -Path "C:\temp\d365fo.tools\AzCopy\AzCopy.exe"
```

This will update the path for the AzCopy.exe in the modules configuration

## PARAMETERS

### -Path
Path to the AzCopy.exe

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
