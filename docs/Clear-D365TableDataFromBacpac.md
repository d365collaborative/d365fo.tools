---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Clear-D365TableDataFromBacpac

## SYNOPSIS
Clear out data for a table inside the bacpac file

## SYNTAX

```
Clear-D365TableDataFromBacpac [-Path] <String> [-TableName] <String[]> [-OutputPath] <String>
 [[-ExtractionPath] <String>] [-KeepFiles] [<CommonParameters>]
```

## DESCRIPTION
Remove all data for a table inside a bacpac file, before restoring it into your SQL Server / Azure SQL DB

It will extract the bacpac file as a zip archive, locate the desired table and remove the data that otherwise would have been loaded

It will re-zip / compress a new bacpac file for you

## EXAMPLES

### EXAMPLE 1
```
Clear-D365TableDataFromBacpac -Path "C:\Temp\AxDB.bacpac" -TableName "BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
```

This will remove the data from the BatchJobHistory table from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "BATCHJOBHISTORY" as the TableName to delete data from.
It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".

It will delete the extracted files after storing the updated bacpac file.

### EXAMPLE 2
```
Clear-D365TableDataFromBacpac -Path "C:\Temp\AxDB.bacpac" -TableName "BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac" -KeepFiles
```

This will remove the data from the BatchJobHistory table from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "BATCHJOBHISTORY" as the TableName to delete data from.
It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".

It will NOT delete the extracted files after storing the updated bacpac file.

### EXAMPLE 3
```
Clear-D365TableDataFromBacpac -Path "C:\Temp\AxDB.bacpac" -TableName "dbo.BATCHHISTORY","BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
```

This will remove the data from the BatchJobHistory table from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "dbo.BATCHHISTORY","BATCHJOBHISTORY" as the TableName to delete data from.
It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".

It will delete the extracted files after storing the updated bacpac file.

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

### -TableName
Name of the table that you want to delete the data for

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
Path to where you want the updated bacpac file to be saved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtractionPath
Path to where you want the cmdlet to extract the files from the bacpac file while it deletes data

The default value is "c:\temp\d365fo.tools\BacpacExtractions"

When working the cmdlet will create a sub-folder named like the bacpac file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $(Join-Path $Script:DefaultTempPath "BacpacExtractions")
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeepFiles
Switch to instruct the cmdlet to keep the extracted files and folders

This will leave the files in place, after the deletion of the desired data

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
Tags: Bacpac, Servicing, Data, Deletion, SqlPackage

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
