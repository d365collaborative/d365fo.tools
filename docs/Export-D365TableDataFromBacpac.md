---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Export-D365TableDataFromBacpac

## SYNOPSIS
Export data from a table inside the bacpac file

## SYNTAX

```
Export-D365TableDataFromBacpac [-Path] <String> [-TableName] <String[]> [[-OutputPath] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Export all data for a table inside a bacpac file into a directory

It will convert the bacpac file to a zip archive, locate the desired table and extract all the bulk files for that specific table

It will revert the zip back to bacpac file for you

Caution:
Working against big bacpac files (10+ GB) will put pressure on your memory consumption on the machine where you run this command

## EXAMPLES

### EXAMPLE 1
```
Export-D365TableDataFromBacpac -Path "C:\Temp\AxDB.bacpac" -TableName "BATCHJOBHISTORY" -OutputPath "C:\Temp\Extract"
```

This will extract the bulk data from the BatchJobHistory table from inside the bacpac file and output it to "C:\Temp\Extract".

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "BATCHJOBHISTORY" as the TableName to extract data from, and will default to the "dbo" schema.
It uses "C:\Temp\Extract\dbo.BatchJobHistory" as the OutputPath to where it will store the extracted bulk data file(s).

## PARAMETERS

### -Path
Path to the bacpac file that you want to work against

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

### -TableName
Name of the table that you want to export the data from

Supports an array of table names

If a schema name isn't supplied as part of the table name, the cmdlet will prefix it with "dbo."

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Path to where you want the bulk data exported to be saved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $(Join-Path $Script:DefaultTempPath "BacpacTables")
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Bacpac, Servicing, Data, SqlPackage, Bulk, Export, Extract

Author: Mötz Jensen (@Splaxi)

Caution:
Working against big bacpac files (10+ GB) will put pressure on your memory consumption on the machine where you run this command

## RELATED LINKS
