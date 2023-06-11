---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Clear-D365BacpacObject

## SYNOPSIS
Clear out sql objects from inside the bacpac/dacpac or zip file

## SYNTAX

### Copy (Default)
```
Clear-D365BacpacObject -Path <String> -Name <String[]> [-ObjectType <String>] -OutputPath <String>
 [<CommonParameters>]
```

### Keep
```
Clear-D365BacpacObject -Path <String> -Name <String[]> [-ObjectType <String>] [-ClearFromSource]
 [<CommonParameters>]
```

## DESCRIPTION
Remove a set of sql objects from inside a bacpac/dacpac or zip file, before restoring it into your SQL Server / Azure SQL DB

It will open the file as a zip archive, locate the desired sql object and remove it, so when importing the bacpac the object will not be created

The default behavior is that you get a copy of the file, where the desired sql objects are removed

## EXAMPLES

### EXAMPLE 1
```
Clear-D365BacpacObject -Path "C:\Temp\AxDB.bacpac" -ObjectType SqlView -Name "View2" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
```

This will remove the SqlView "View2" from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "View2" as the name of the object to delete.
It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.

### EXAMPLE 2
```
Clear-D365BacpacObject -Path "C:\Temp\AxDB.bacpac" -ObjectType SqlView -Name "dbo.View1","View2" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
```

This will remove the SqlView(s) "dbo.View1" and "View2" from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "dbo.View1","View2" as the names of objects to delete.
It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.

### EXAMPLE 3
```
Clear-D365BacpacObject -Path "C:\Temp\AxDB.bacpac" -ObjectType SqlIndex -Name "[dbo].[SalesTable].[CustomIndexName1]" -ClearFromSource
```

This will remove the SqlIndex "CustomIndexName1" from the dbo.SalesTable table from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "\[dbo\].\[SalesTable\].\[CustomIndexName1\]" as the name of the object to delete.

Caution:
It will remove from the source "C:\Temp\AxDB.bacpac" directly.
So if the original file is important for further processing, please consider the risks carefully.

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

### -Name
Name of the sql object that you want to remove

Supports an array of names

If a schema name isn't supplied as part of the table name, the cmdlet will prefix it with "dbo."

Some sql objects are 3 part named, which will require that you fill them in with brackets E.g.
\[dbo\].\[SalesTable\].\[CustomIndexName1\]
- Index
- Constraints

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: ObjectName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectType
Instruct the cmdlet, the type of object that you want to remove

As we are manipulating the bacpac file, we can only handle 1 ObjectType per run

If you want to remove SqlView and SqlIndex, you will have to run the cmdlet 1 time for SqlViews and 1 time for SqlIndex

Supported types are:
"SqlView", "SqlTable", "SqlIndex", "SqlCheckConstraint"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
Instruct the cmdlet to delete sql objects directly from the source file

It will save disk space and time, because it doesn't have to create a copy of the bacpac file, before deleting sql objects from it

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
It will NOT fail, if it can't find any object with the specified name

## RELATED LINKS
