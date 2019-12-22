---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365SqlOptionsFromBacpacModelFile

## SYNOPSIS
Get the SQL Server options from the bacpac model.xml file

## SYNTAX

```
Get-D365SqlOptionsFromBacpacModelFile [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Extract the SQL Server options that are listed inside the model.xml file originating from a bacpac file

## EXAMPLES

### EXAMPLE 1
```
Get-D365SqlOptionsFromBacpacModelFile -Path "C:\Temp\model.xml"
```

This will display all the SQL Server options configured in the bacpac file.

### EXAMPLE 2
```
Export-d365ModelFileFromBacpac -Path "C:\Temp\AxDB.bacpac" -OutputPath "C:\Temp\model.xml" | Get-D365SqlOptionsFromBacpacModelFile
```

This will display all the SQL Server options configured in the bacpac file.
First it will export the model.xml from the "C:\Temp\AxDB.bacpac" file, using the Export-d365ModelFileFromBacpac function.
The output from Export-d365ModelFileFromBacpac will be piped into the Get-D365SqlOptionsFromBacpacModelFile function.

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
Accept pipeline input: True (ByPropertyName, ByValue)
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
