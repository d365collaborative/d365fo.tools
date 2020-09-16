---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Publish-D365SsrsReport

## SYNOPSIS
Deploy Report

## SYNTAX

```
Publish-D365SsrsReport [[-Module] <String[]>] [[-ReportName] <String[]>] [[-LogFile] <String>]
 [[-PackageDirectory] <String>] [[-ToolsBasePath] <String>] [[-ReportServerIp] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Deploy SSRS Report to SQL Server Reporting Services

## EXAMPLES

### EXAMPLE 1
```
Publish-D365SsrsReport -Module ApplicationSuite -ReportName TaxVatRegister.Report
```

This will deploy the report which is named "TaxVatRegister.Report".
The cmdlet will look for the report inside the ApplicationSuite module.
The cmdlet will be using the default 127.0.0.1 while deploying the report.

### EXAMPLE 2
```
Publish-D365SsrsReport -Module ApplicationSuite -ReportName *
```

This will deploy the all reports from the ApplicationSuite module.
The cmdlet will be using the default 127.0.0.1 while deploying the report.

## PARAMETERS

### -Module
Name of the module that you want to works against

Accepts an array of strings

Default value is "*" and will work against all modules loaded on the machine

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportName
Name of the report that you want to deploy

Default value is "*" and will deploy all reports from the module(s) that you speficied

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogFile
Path to the file that should contain the logging information

Default value is "c:\temp\d365fo.tools\AxReportDeployment.log"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: (Join-Path $Script:DefaultTempPath "AxReportDeployment.log")
Accept pipeline input: False
Accept wildcard characters: False
```

### -PackageDirectory
Path to the PackagesLocalDirectory

Default path is the same as the AOS Service PackagesLocalDirectory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:PackageDirectory
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToolsBasePath
Base path to the folder containing the needed PowerShell manifests that the cmdlet utilizes

Default path is the same as the AOS Service PackagesLocalDirectory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:PackageDirectory
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportServerIp
IP Address of the server that has SQL Reporting Services installed

Default value is "127.0.01"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 127.0.0.1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [PsCustomObject]
## NOTES
Tags: SSRS, Report, Reports, Deploy, Publish

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
