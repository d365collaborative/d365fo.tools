---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version: https://msdyn365fo.wordpress.com/2019/12/18/cleanup-tempdb-tables-in-a-msdyn365fo-sandbox-environment/
schema: 2.0.0
---

# Clear-D365TempDbTables

## SYNOPSIS
Cleanup TempDB tables in Microsoft Dynamics 365 for Finance and Operations environment

## SYNTAX

```
Clear-D365TempDbTables [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [[-Days] <Int32>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
This will cleanup X days of TempDB tables

The reason behind this process is that sp_updatestats takes significantly longer depending on the number of TempDB tables in the system

## EXAMPLES

### EXAMPLE 1
```
Clear-D365TempDbTables -Days 7
```

This will cleanup old tempdb tables.
It will use 7 as the Days parameter.

The remaining parameters will use their default values, which are provided by the tools.

## PARAMETERS

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
Position: 1
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
Position: 2
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
Position: 3
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
Position: 4
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### -Days
Temp tables older than this Days input will be dropped

The default value is 7 (days)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 7
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts

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
Author: Alex Kwitny (@AlexOnDAX)

Author: Mötz Jensen (@Splaxi)

This cmdlet is based on the findings from Paul Heisterkamp (@braul)

See his blog for more info:
https://msdyn365fo.wordpress.com/2019/12/18/cleanup-tempdb-tables-in-a-msdyn365fo-sandbox-environment/

## RELATED LINKS

[https://msdyn365fo.wordpress.com/2019/12/18/cleanup-tempdb-tables-in-a-msdyn365fo-sandbox-environment/](https://msdyn365fo.wordpress.com/2019/12/18/cleanup-tempdb-tables-in-a-msdyn365fo-sandbox-environment/)

[https://github.com/PaulHeisterkamp/d365fo.blog/blob/master/Tools/SQL/DropTempDBTables.sql](https://github.com/PaulHeisterkamp/d365fo.blog/blob/master/Tools/SQL/DropTempDBTables.sql)

