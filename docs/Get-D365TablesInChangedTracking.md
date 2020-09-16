---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365TablesInChangedTracking

## SYNOPSIS
Get table that is taking part of Change Tracking

## SYNTAX

```
Get-D365TablesInChangedTracking [[-Name] <String>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get table(s) that is taking part of the SQL Server Change Tracking mechanism

## EXAMPLES

### EXAMPLE 1
```
Get-D365TablesInChangedTracking
```

This will list all tables that are taking part in the SQL Server Change Tracking.

### EXAMPLE 2
```
Get-D365TablesInChangedTracking -Name CustTable
```

This will search for a table in the list of tables that are taking part in the SQL Server Change Tracking.
It will use the CustTable as the search pattern while searching for the table.

## PARAMETERS

### -Name
Name of the table that you are looking for

Accepts wildcards for searching.
E.g.
-Name "Cust*"

Default value is "*" which will search for all tables

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
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
Position: 2
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
Position: 3
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
Position: 4
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
Position: 5
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Table, Change Tracking, Tablename, DMF, DIXF

Author: Mötz Jensen (@splaxi)

## RELATED LINKS
