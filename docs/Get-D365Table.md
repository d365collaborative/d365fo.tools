---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Table

## SYNOPSIS
Get a table

## SYNTAX

### Default (Default)
```
Get-D365Table [[-Name] <String[]>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [<CommonParameters>]
```

### TableId
```
Get-D365Table [-Id] <Int32> [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get a table either by TableName (wildcard search allowed) or by TableId

## EXAMPLES

### EXAMPLE 1
```
Get-D365Table -Name CustTable
```

Will get the details for the CustTable

### EXAMPLE 2
```
Get-D365Table -Id 10347
```

Will get the details for the table with the id 10347.

## PARAMETERS

### -Name
Name of the table that you are looking for

Accepts wildcards for searching.
E.g.
-Name "Cust*"

Default value is "*" which will search for all tables

```yaml
Type: String[]
Parameter Sets: Default
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The specific id for the table you are looking for

```yaml
Type: Int32
Parameter Sets: TableId
Aliases:

Required: True
Position: 2
Default value: 0
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
The password for the SQL Server user

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
The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

Author: Mötz Jensen (@splaxi)

## RELATED LINKS
