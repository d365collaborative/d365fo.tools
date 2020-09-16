---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365TraceParserFileSize

## SYNOPSIS
Configue a new maximum file size for the TraceParser

## SYNTAX

```
Set-D365TraceParserFileSize [-FileSizeInMB] <String> [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Change the maximum file size that the TraceParser generates

## EXAMPLES

### EXAMPLE 1
```
Set-D365TraceParserFileSize -FileSizeInMB 2048
```

This will configure the maximum TraceParser file to 2048 MB.

## PARAMETERS

### -FileSizeInMB
The maximum size that you want to allow the TraceParser file to grow to

Original value inside the configuration is 1024 (MB)

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

### -Path
The path to the TraceParser.config file that you want to edit

The default path is: "\AosService\Webroot\Services\TraceParserService\TraceParserService.config"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Join-Path $Script:AOSPath "Services\TraceParserService\TraceParserService.config")
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
