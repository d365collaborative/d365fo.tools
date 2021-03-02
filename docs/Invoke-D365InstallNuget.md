---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365InstallNuget

## SYNOPSIS
Download nuget.exe to your machine

## SYNTAX

```
Invoke-D365InstallNuget [[-Path] <String>] [[-Url] <String>] [<CommonParameters>]
```

## DESCRIPTION
Download the nuget.exe to your machine

By default it will download the latest version

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365InstallNuget
```

This will download the latest version of nuget.
The install path is identified by the default value: "C:\temp\d365fo.tools\nuget\nuget.exe".

## PARAMETERS

### -Path
Path to where you want the nuget.exe to be downloaded to

Default value is: "C:\temp\d365fo.tools\nuget\nuget.exe"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: C:\temp\d365fo.tools\nuget
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
Url/Uri to where the latest nuget download is located

The default value is "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
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
