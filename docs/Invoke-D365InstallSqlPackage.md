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
Invoke-D365InstallSqlPackage [[-Path] <String>] [-SkipExtractFromPage] [[-Url] <String>] [<CommonParameters>]
```

## DESCRIPTION
Download and extract the DotNet/.NET core x64 edition of the SqlPackage.exe to your machine

It parses the raw html page and tries to extract the latest download link.
As of 12th April 2022, no .NET Core link is available on the download page.
The cmdlet will always use the Url parameter.

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365InstallSqlPackage
```

This will download and extract the latest SqlPackage.exe.
It will use the default value for the Path parameter, for where to save the SqlPackage.exe.
It will try to extract the latest download URL from the RAW html page.
It will update the path for the SqlPackage.exe in configuration.

### EXAMPLE 2
```
Invoke-D365InstallSqlPackage -Path "C:\temp\SqlPackage"
```

This will download and extract the latest SqlPackage.exe.
It will try to extract the latest download URL from the RAW html page.
It will update the path for the SqlPackage.exe in configuration.

### EXAMPLE 3
```
Invoke-D365InstallSqlPackage -SkipExtractFromPage
```

This will download and extract the latest SqlPackage.exe.
It will rely on the Url parameter to based the download from.
It will use the default value of the Url parameter.
It will update the path for the SqlPackage.exe in configuration.

### EXAMPLE 4
```
Invoke-D365InstallSqlPackage -SkipExtractFromPage -Url "https://go.microsoft.com/fwlink/?linkid=3030303"
```

This will download and extract the latest SqlPackage.exe.
It will rely on the Url parameter to based the download from.
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
Position: 1
Default value: C:\temp\d365fo.tools\SqlPackage
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipExtractFromPage
Instruct the cmdlet to skip trying to parse the download page and to rely on the Url parameter only

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

### -Url
Url/Uri to where the latest SqlPackage download is located

The default value is for v19.1 (16.0.6161.0) as of writing.
This is the last version of SqlPackage based on .NET Core.
According to the Microsoft documentation, a .NET Core version of SqlPackage should be used.
https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/database/import-database
Further discussion can be found here: https://github.com/d365collaborative/d365fo.tools/issues/708

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Https://go.microsoft.com/fwlink/?linkid=2196334
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
