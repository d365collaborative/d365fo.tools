---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365TableField

## SYNOPSIS
Get a field from table

## SYNTAX

### Default (Default)
```
Get-D365TableField [-TableId] <Int32> [[-Name] <String>] [[-FieldId] <Int32>] [[-DatabaseServer] <String>]
 [[-DatabaseName] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>] [-IncludeTableDetails]
 [<CommonParameters>]
```

### SearchByNameForce
```
Get-D365TableField [[-Name] <String>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [-SearchAcrossTables] [<CommonParameters>]
```

### TableName
```
Get-D365TableField [[-Name] <String>] [[-FieldId] <Int32>] [[-DatabaseServer] <String>]
 [[-DatabaseName] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>] [-TableName] <String>
 [-IncludeTableDetails] [<CommonParameters>]
```

## DESCRIPTION
Get a field either by FieldName (wildcard search allowed) or by FieldId

## EXAMPLES

### EXAMPLE 1
```
Get-D365TableField -TableId 10347
```

Will get all field details for the table with id 10347.

### EXAMPLE 2
```
Get-D365TableField -TableName CustTable
```

Will get all field details for the CustTable table.

### EXAMPLE 3
```
Get-D365TableField -TableId 10347 -FieldId 175
```

Will get the details for the field with id 175 that belongs to the table with id 10347.

### EXAMPLE 4
```
Get-D365TableField -TableId 10347 -Name "VATNUM"
```

Will get the details for the "VATNUM" that belongs to the table with id 10347.

### EXAMPLE 5
```
Get-D365TableField -TableId 10347 -Name "VAT*"
```

Will get the details for all fields that fits the search "VAT*" that belongs to the table with id 10347.

### EXAMPLE 6
```
Get-D365TableField -Name AccountNum -SearchAcrossTables
```

Will search for the AccountNum field across all tables.

### EXAMPLE 7
```
Get-D365TableField -TableName CustTable -IncludeTableDetails
```

Will get all field details for the CustTable table.
Will include table details in the output.

## PARAMETERS

### -TableId
The id of the table that the field belongs to

```yaml
Type: Int32
Parameter Sets: Default
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the field that you are looking for

Accepts wildcards for searching.
E.g.
-Name "Account*"

Default value is "*" which will search for all fields

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -FieldId
Id of the field that you are looking for

Type is integer

```yaml
Type: Int32
Parameter Sets: Default, TableName
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DatabaseServer
The name of the database server

If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN)

If Azure use the full address to the database server, e.g.
server.database.windows.net

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
Default value: $Script:DatabaseName
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlUser
The login name for the SQL Server instance

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Script:DatabaseUserName
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlPwd
The password for the SQL Server user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### -TableName
Name of the table that the field belongs to

Search will only return the first hit (unordered) and work against that hit

```yaml
Type: String
Parameter Sets: TableName
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeTableDetails
Switch options to enable the result set to include extended details

```yaml
Type: SwitchParameter
Parameter Sets: Default, TableName
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchAcrossTables
Switch options to force the cmdlet to search across all tables when looking for the field

```yaml
Type: SwitchParameter
Parameter Sets: SearchByNameForce
Aliases:

Required: True
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Table, Tables, Fields, TableField, Table Field, TableName, TableId

Author: Mötz Jensen (@splaxi)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
