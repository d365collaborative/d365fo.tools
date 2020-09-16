---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Switch-D365ActiveDatabase

## SYNOPSIS
Switches the 2 databases.
The Old wil be renamed _original

## SYNTAX

```
Switch-D365ActiveDatabase [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [-SourceDatabaseName] <String> [[-DestinationSuffix] <String>] [-EnableException]
 [<CommonParameters>]
```

## DESCRIPTION
Switches the 2 databases.
The Old wil be renamed _original

## EXAMPLES

### EXAMPLE 1
```
Switch-D365ActiveDatabase -SourceDatabaseName "GoldenConfig"
```

This will switch the default database AXDB out and put "GoldenConfig" in its place instead.
It will use the default value for DestinationSuffix which is "_original".
The destination database "AXDB" will be renamed to "AXDB_original".
The GoldenConfig database will be renamed to "AXDB".

### EXAMPLE 2
```
Switch-D365ActiveDatabase -SourceDatabaseName "AXDB_original" -DestinationSuffix "_reverted"
```

This will switch the default database AXDB out and put "AXDB_original" in its place instead.
It will use the "_reverted" value for DestinationSuffix parameter.
The destination database "AXDB" will be renamed to "AXDB_reverted".
The "AXDB_original" database will be renamed to "AXDB".

This is used when you did a switch already and need to switch back to the original database.

This example assumes that the used the first example to switch in the GoldenConfig database with default parameters.

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
Aliases: DestinationDatabaseName

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

### -SourceDatabaseName
The database that takes the DatabaseName's place

```yaml
Type: String
Parameter Sets: (All)
Aliases: NewDatabaseName

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationSuffix
The suffix that you want to append onto the database that is being switched out (DestinationDatabaseName / DatabaseName)

The default value is "_original" to mimic the official guides from Microsoft

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: _original
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
Author: Mötz Jensen (@Splaxi)

Author: Rasmus Andersen (@ITRasmus)

## RELATED LINKS
