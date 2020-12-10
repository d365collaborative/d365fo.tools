---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365BulkImportTableData

## SYNOPSIS
Import data into a table

## SYNTAX

```
Invoke-D365BulkImportTableData [-Path] <String> [[-TableName] <String>] [[-Schema] <String>]
 [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [-ShowOriginalProgress] [-OutputCommandOnly]
 [<CommonParameters>]
```

## DESCRIPTION
Import bulk data into a table in the Dynamics 365 Finance & Operations database

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365BulkImportTableData -Path "C:\Temp\SalesTable" -TableName "SalesTable"
```

This will import all the bulk data in the "C:\Temp\SalesTable" folder into the "SalesTable".
It will use the default value "dbo" for the Schema parameter.
It will use the default DatabaseServer value.
It will use the default DatabaseName value.

Caution:
You will need to delete or truncate the table you want to bulk import into.
If you don't, you might experience issues while inserting new records, if you have conflicting id's in the table.

### EXAMPLE 2
```
Invoke-D365BulkImportTableData -Path "C:\Temp\SalesTable" -Schema "dbo" -TableName "SalesTable"
```

This will import all the bulk data in the "C:\Temp\SalesTable" folder into the "SalesTable".
It will use the value "dbo" for the Schema parameter.
It will use the default DatabaseServer value.
It will use the default DatabaseName value.

Caution:
You will need to delete or truncate the table you want to bulk import into.
If you don't, you might experience issues while inserting new records, if you have conflicting id's in the table.

## PARAMETERS

### -Path
Path to the folder containing the bulk files that you want to import into the table

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
Name of the table that you want to import data into

Caution:
You will need to delete or truncate the table you want to bulk import into.
If you don't, you might experience issues while inserting new records, if you have conflicting id's in the table

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Schema
Name of the schema that you are trying to import into

Default value is "dbo"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Dbo
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseServer
The name of the database server

If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).

If Azure use the full address to the database server, e.g.
server.database.windows.net

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:DatabaseServer
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
The name of the database

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:DatabaseName
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowOriginalProgress
Instruct the cmdlet to show the standard output in the console

Default is $false which will silence the standard output

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

### -OutputCommandOnly
Instruct the cmdlet to only output the command that you would have to execute by hand

Will include full path to the executable and the needed parameters based on your selection

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Bulk, Data, Import, bacpac

Author: Mötz Jensen (@Splaxi)

Caution:
You will need to delete or truncate the table you want to bulk import into.
If you don't, you might experience issues while inserting new records, if you have conflicting id's in the table.

You might run into issues with foreign key references and constraints.
None of this is handled by this cmdlet.
It will try to import the data as-is into the table and nothing more.

## RELATED LINKS
