---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Clear-D365BacpacTableData

## SYNOPSIS
Clear out data for a table inside the bacpac/dacpac or zip file

## SYNTAX

### Copy (Default)
```
Clear-D365BacpacTableData -Path <String> -Table <String[]> -OutputPath <String> [<CommonParameters>]
```

### Keep
```
Clear-D365BacpacTableData -Path <String> -Table <String[]> [-ClearFromSource] [<CommonParameters>]
```

## DESCRIPTION
Remove all data for a table inside a bacpac/dacpac or zip file, before restoring it into your SQL Server / Azure SQL DB

It will open the file as a zip archive, locate the desired table and remove the data that otherwise would have been loaded

The default behavior is that you get a copy of the file, where the desired data is removed

## EXAMPLES

### EXAMPLE 1
```
Clear-D365BacpacTableData -Path "C:\Temp\AxDB.bacpac" -Table "BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
```

This will remove the data from the BatchJobHistory table from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "BATCHJOBHISTORY" as the Table to delete data from.
It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.

### EXAMPLE 2
```
Clear-D365BacpacTableData -Path "C:\Temp\AxDB.bacpac" -Table "dbo.BATCHHISTORY","BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
```

This will remove the data from the dbo.BatchHistory and BatchJobHistory table from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "dbo.BATCHHISTORY","BATCHJOBHISTORY" as the Table to delete data from.
It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.

### EXAMPLE 3
```
Clear-D365BacpacTableData -Path "C:\Temp\AxDB.bacpac" -Table "dbo.BATCHHISTORY","BATCHJOBHISTORY" -ClearFromSource
```

This will remove the data from the dbo.BatchHistory and BatchJobHistory table from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "dbo.BATCHHISTORY","BATCHJOBHISTORY" as the Table to delete data from.

Caution:
It will remove from the source "C:\Temp\AxDB.bacpac" directly.
So if the original file is important for further processing, please consider the risks carefully.

### EXAMPLE 4
```
Clear-D365BacpacTableData -Path "C:\Temp\AxDB.bacpac" -Table "CustomTableNameThatDoesNotExists","BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac" -ErrorAction SilentlyContinue
```

This will remove the data from the BatchJobHistory table from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "CustomTableNameThatDoesNotExists","BATCHJOBHISTORY" as the Table to delete data from.
It respects the respects the ErrorAction "SilentlyContinue", and will continue removing tables from the bacpac file, even when some tables are missing.
It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.

## PARAMETERS

### -Path
Path to the bacpac/dacpac or zip file that you want to work against

```yaml
Type: String
Parameter Sets: (All)
Aliases: BacpacFile, File

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Table
Name of the table that you want to delete the data for

Supports an array of table names

If a schema name isn't supplied as part of the table name, the cmdlet will prefix it with "dbo."

Supports wildcard searching e.g.
"Sales*" will delete all "dbo.Sales*" tables in the bacpac file

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: TableName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Path to where you want the updated bacpac/dacpac or zip file to be saved

```yaml
Type: String
Parameter Sets: Copy
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClearFromSource
Instruct the cmdlet to delete tables directly from the source file

It will save disk space and time, because it doesn't have to create a copy of the bacpac file, before deleting tables from it

```yaml
Type: SwitchParameter
Parameter Sets: Keep
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Bacpac, Servicing, Data, Deletion, SqlPackage

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
