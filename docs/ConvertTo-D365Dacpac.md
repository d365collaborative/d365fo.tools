---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version: https://msdyn365fo.wordpress.com/2019/12/18/cleanup-tempdb-tables-in-a-msdyn365fo-sandbox-environment/
schema: 2.0.0
---

# ConvertTo-D365Dacpac

## SYNOPSIS
Convert bacpac file to dacpac

## SYNTAX

```
ConvertTo-D365Dacpac [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Convert bacpac file to dacpac

It will extract the origin.xml file from the file, and set the \<ContainsExportedData\>false\</ContainsExportedData\> for the file to be valid to be used as a dacpac file

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Path
Path to the bacpac file that you want to work against

It can also be a zip file

```yaml
Type: String
Parameter Sets: (All)
Aliases: BacpacFile, File

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
Tags: Bacpac, Servicing, Data, SqlPackage, Dacpac, Table

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
