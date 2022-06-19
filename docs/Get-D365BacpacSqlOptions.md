---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365BacpacSqlOptions

## SYNOPSIS
Get the SQL Server options from the bacpac model.xml file

## SYNTAX

```
Get-D365BacpacSqlOptions [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Extract the SQL Server options that are listed inside the model.xml file originating from a bacpac file

## EXAMPLES

### EXAMPLE 1
```
Get-D365BacpacSqlOptions -Path "c:\temp\d365fo.tools\bacpac.model.xml"
```

This will display all the SQL Server options configured in the bacpac model file.

### EXAMPLE 2
```
Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac" | Get-D365BacpacSqlOptions
```

This will display all the SQL Server options configured in the bacpac file.
First it will export the model.xml from the "c:\Temp\AxDB.bacpac" file, using the Export-D365BacpacModelFile function.
The output from Export-D365BacpacModelFile will be piped into the Get-D365BacpacSqlOptions function.

## PARAMETERS

### -Path
Path to the extracted model.xml file that you want to work against

```yaml
Type: String
Parameter Sets: (All)
Aliases: File, ModelFile

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Bacpac, Servicing, Data, SqlPackage, Sql Server Options, Collation

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
