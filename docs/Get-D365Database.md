---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Database

## SYNOPSIS
Get databases from the server

## SYNTAX

```
Get-D365Database [[-Name] <String[]>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get the names of databases on either SQL Server or in Azure SQL Database instance

## EXAMPLES

### EXAMPLE 1
```
Get-D365Database
```

This will show all databases on the default SQL Server / Azure SQL Database instance.

### EXAMPLE 2
```
Get-D365Database -Name AXDB_ORIGINAL
```

This will show if the AXDB_ORIGINAL database exists on the default SQL Server / Azure SQL Database instance.

## PARAMETERS

### -Name
Name of the database that you are looking for

Default value is "*" which will show all databases

```yaml
Type: String[]
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

If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).

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

### [PsCustomObject]
## NOTES
Tags: Database, DB, Servicing

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
