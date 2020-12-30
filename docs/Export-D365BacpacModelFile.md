---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Export-D365BacpacModelFile

## SYNOPSIS
Extract the "model.xml" from the bacpac file

## SYNTAX

```
Export-D365BacpacModelFile [-Path] <String> [[-OutputPath] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Extract the "model.xml" file from inside the bacpac file

This can be used to update SQL Server options for how the SqlPackage.exe should import the bacpac file into your SQL Server / Azure SQL DB

## EXAMPLES

### EXAMPLE 1
```
Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac"
```

This will extract the "model.xml" file from inside the bacpac file.

It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses the default value "c:\temp\d365fo.tools" as the OutputPath to where it will store the extracted "bacpac.model.xml" file.

### EXAMPLE 2
```
Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac" -OutputPath "c:\Temp\model.xml" -Force
```

This will extract the "model.xml" file from inside the bacpac file.

It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "c:\Temp\model.xml" as the OutputPath to where it will store the extracted "model.xml" file.

It will override the "c:\Temp\model.xml" if already present.

### EXAMPLE 3
```
Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac" | Get-D365BacpacSqlOptions
```

This will display all the SQL Server options configured in the bacpac file.
First it will export the bacpac.model.xml from the "c:\Temp\AxDB.bacpac" file, using the Export-D365BacpacModelFile function.
The output from Export-D365BacpacModelFile will be piped into the Get-D365BacpacSqlOptions function.

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

### -OutputPath
Path to where you want the updated bacpac file to be saved

Default value is: "c:\temp\d365fo.tools"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:DefaultTempPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Switch to instruct the cmdlet to overwrite the "model.xml" specified in the OutputPath

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
Tags: Bacpac, Servicing, Data, SqlPackage, Sql Server Options, Collation

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
