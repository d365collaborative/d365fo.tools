---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365InstallSqlPackage

## SYNOPSIS
Download SqlPackage.exe to your machine

## SYNTAX

```
Invoke-D365InstallSqlPackage [[-Url] <String>] [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Download and extract the DotNet/.NET core x64 edition of the SqlPackage.exe to your machine

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365InstallSqlPackage -Path "C:\temp\d365fo.tools\SqlPackage"
```

This will update the path for the SqlPackage.exe in the modules configuration

## PARAMETERS

### -Url
Url/Uri to where the latest SqlPackage download is located

The default value is for v18.4 as of writing

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://go.microsoft.com/fwlink/?linkid=2109019
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to where you want the SqlPackage to be extracted to

Default value is: "C:\temp\d365fo.tools\SqlPackage\SqlPackage.exe"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: C:\temp\d365fo.tools\SqlPackage
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
