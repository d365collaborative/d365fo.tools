---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365InstallAzCopy

## SYNOPSIS
Download AzCopy.exe to your machine

## SYNTAX

```
Invoke-D365InstallAzCopy [[-Url] <String>] [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Download and extract the AzCopy.exe to your machine

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365InstallAzCopy -Path "C:\temp\d365fo.tools\AzCopy\AzCopy.exe"
```

This will update the path for the AzCopy.exe in the modules configuration

## PARAMETERS

### -Url
Url/Uri to where the latest AzCopy download is located

The default value is for v10 as of writing

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://aka.ms/downloadazcopy-v10-windows
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to where you want the AzCopy to be extracted to

Default value is: "C:\temp\d365fo.tools\AzCopy\AzCopy.exe"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: C:\temp\d365fo.tools\AzCopy\AzCopy.exe
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
