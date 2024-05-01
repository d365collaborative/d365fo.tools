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

### ImportUrl (Default)
```
Invoke-D365InstallSqlPackage [-Path <String>] [-Url <String>] [<CommonParameters>]
```

### ImportLatest
```
Invoke-D365InstallSqlPackage [-Path <String>] [-Latest] [<CommonParameters>]
```

## DESCRIPTION
Download and extract SqlPackage.exe to your machine.

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365InstallSqlPackage
```

This will download and extract SqlPackage.exe.
It will use the default value for the Path parameter, for where to save the SqlPackage.exe.
It will update the path for the SqlPackage.exe in configuration.

### EXAMPLE 2
```
Invoke-D365InstallSqlPackage -Path "C:\temp\SqlPackage"
```

This will download and extract SqlPackage.exe.
It will save the SqlPackage.exe to "C:\temp\SqlPackage".
It will update the path for the SqlPackage.exe in configuration.

### EXAMPLE 3
```
Invoke-D365InstallSqlPackage -Latest
```

This will download and extract the latest SqlPackage.exe.
It will use https://aka.ms/sqlpackage-windows as the download URL.
It will update the path for the SqlPackage.exe in configuration.

### EXAMPLE 4
```
Invoke-D365InstallSqlPackage -Url "https://go.microsoft.com/fwlink/?linkid=3030303"
```

This will download and extract SqlPackage.exe.
It will rely on the Url parameter to base the download on.
It will use the "https://go.microsoft.com/fwlink/?linkid=3030303" as value for the Url parameter.
It will update the path for the SqlPackage.exe in configuration.

## PARAMETERS

### -Path
Path to where you want the SqlPackage to be extracted to

Default value is: "C:\temp\d365fo.tools\SqlPackage\SqlPackage.exe"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: C:\temp\d365fo.tools\SqlPackage
Accept pipeline input: False
Accept wildcard characters: False
```

### -Latest
Overrides the Url parameter and uses the latest download URL provided by the evergreen link https://aka.ms/sqlpackage-windows

```yaml
Type: SwitchParameter
Parameter Sets: ImportLatest
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
Url/Uri to where the SqlPackage download is located

The default value is for version 162.2.111.2 as of writing.

Further discussion can be found here: https://github.com/d365collaborative/d365fo.tools/discussions/816

```yaml
Type: String
Parameter Sets: ImportUrl
Aliases:

Required: False
Position: Named
Default value: Https://go.microsoft.com/fwlink/?linkid=2261576
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)
Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS
