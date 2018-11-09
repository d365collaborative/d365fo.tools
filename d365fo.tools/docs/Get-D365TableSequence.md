---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365TableSequence

## SYNOPSIS
Get the sequence object for table

## SYNTAX

```
Get-D365TableSequence [[-TableName] <String>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get the sequence details for tables

## EXAMPLES

### EXAMPLE 1
```
Get-D365TableSequence | Format-Table
```

This will get all the sequence details for all tables inside the database.
It will format the output as a table for better overview.

### EXAMPLE 2
```
Get-D365TableSequence -TableName "Custtable" | Format-Table
```

This will get the sequence details for the CustTable in the database.
It will format the output as a table for better overview.

### EXAMPLE 3
```
Get-D365TableSequence -TableName "Cust*" | Format-Table
```

This will get the sequence details for all tables that matches the search "Cust*" in the database.
It will format the output as a table for better overview.

### EXAMPLE 4
```
Get-D365Table -Name CustTable | Get-D365TableSequence | Format-Table
```

This will get the table details from the Get-D365Table cmdlet and pipe that into Get-D365TableSequence.
This will get the sequence details for the CustTable in the database.
It will format the output as a table for better overview.

## PARAMETERS

### -TableName
Name of the table that you want to work against

Accepts wildcards for searching.
E.g.
-TableName "Cust*"

Default value is "*" which will search for all tables

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 2
Default value: *
Accept pipeline input: True (ByPropertyName)
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
Position: 3
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
Position: 4
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
Position: 5
Default value: $Script:DatabaseUserName
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlPwd
The password for the SQL Server user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Table, RecId, Sequence, Record Id

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
