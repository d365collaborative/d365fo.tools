---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Update-D365BacpacModelFileSingleTable

## SYNOPSIS
Update the "model.xml" from the bacpac file to a single table

## SYNTAX

```
Update-D365BacpacModelFileSingleTable [[-Path] <String>] [-Table] <String> [[-Schema] <String>]
 [[-OutputPath] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Update the "model.xml" file from inside the bacpac file to only handle a single table

This can be used to restore a single table as fast as possible to a new data

The table will be created like ordinary bacpac restore, expect it will only have the raw table definition and indexes, all other objects are dropped

The output can be used directly with the Import-D365Bacpac cmdlet and its ModelFile parameter, see the example sections for more details

## EXAMPLES

### EXAMPLE 1
```
Update-D365BacpacModelFileSingleTable -Path "c:\temp\d365fo.tools\bacpac.model.xml" -Table "SalesTable"
```

This will create an updated bacpac.model.xml file with only the SalesTable to be imported.
It will read the "c:\temp\d365fo.tools\bacpac.model.xml" file.
It will use the default "dbo" as the Schema parameter.
It will use the "SalesTable" as the Table parameter.
It will use the "c:\temp\d365fo.tools\dbo.salestable.model.xml" as the default path for OutputPath parameter.

### EXAMPLE 2
```
Update-D365BacpacModelFileSingleTable -Path "c:\temp\d365fo.tools\bacpac.model.xml" -Table "CommissionSalesGroup" -Schema "AX"
```

This will create an updated bacpac.model.xml file with only the "CommissionSalesGroup", from the "AX" schema, to be imported.
It will read the "c:\temp\d365fo.tools\bacpac.model.xml" file.
It will use the "AX" as the Schema for the table.
It will use the "CommissionSalesGroup" as the Table parameter.
It will use the "c:\temp\d365fo.tools\ax.CommissionSalesGroup.model.xml" as the default path for OutputPath parameter.

### EXAMPLE 3
```
Update-D365BacpacModelFileSingleTable -Path "c:\temp\d365fo.tools\bacpac.model.xml" -Table "SalesTable" -OutputPath "c:\temp\troubleshoot.xml"
```

This will create an updated bacpac.model.xml file with only the SalesTable to be imported.
It will read the "c:\temp\d365fo.tools\bacpac.model.xml" file.
It will use the default "dbo" as the Schema parameter.
It will use the "SalesTable" as the Table parameter.
It will use the "c:\temp\troubleshoot.xml" as the path for OutputPath parameter.

### EXAMPLE 4
```
Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac" | Update-D365BacpacModelFileSingleTable -Table SalesTable
```

This will create an updated bacpac.model.xml file with only the SalesTable to be imported.
It will read the bacpac model file generated from the Export-D365BacpacModelFile cmdlet.
It will use the default "dbo" as the Schema parameter.
It will use the "SalesTable" as the Table parameter.
It will use the "c:\temp\d365fo.tools\dbo.salestable.model.xml" as the default path for OutputPath parameter.

### EXAMPLE 5
```
Update-D365BacpacModelFileSingleTable -Path "c:\temp\d365fo.tools\bacpac.model.xml" -Table "SalesTable" -Force
```

This will create an updated bacpac.model.xml file with only the SalesTable to be imported.
It will read the "c:\temp\d365fo.tools\bacpac.model.xml" file.
It will use the default "dbo" as the Schema parameter.
It will use the "SalesTable" as the Table parameter.
It will use the "c:\temp\d365fo.tools\dbo.salestable.model.xml" as the default path for OutputPath parameter.

It will overwrite the "c:\temp\d365fo.tools\dbo.salestable.model.xml" if it already exists.

## PARAMETERS

### -Path
Path to the bacpac file that you want to work against

It can also be a zip file

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

### -Table
Name of the table that you want to be kept inside the model file when the update is done

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Schema
Schema where the table that you want to work against exists

The default value is "dbo"

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

### -OutputPath
Path to where you want the updated bacpac model file to be saved

Default value is: "c:\temp\d365fo.tools"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:DefaultTempPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Switch to instruct the cmdlet to overwrite the bacpac model file specified in the OutputPath

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
Tags: Bacpac, Servicing, Data, SqlPackage, Import, Table, Troubleshooting

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
