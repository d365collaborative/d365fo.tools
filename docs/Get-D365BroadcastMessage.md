---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365BroadcastMessage

## SYNOPSIS
Get broadcast message from the D365FO environment

## SYNTAX

```
Get-D365BroadcastMessage [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [-ExcludeExpired] [<CommonParameters>]
```

## DESCRIPTION
Get broadcast message from the D365FO environment by looking into the database table

## EXAMPLES

### EXAMPLE 1
```
Get-D365BroadcastMessage
```

This will display all the broadcast message records from the SysBroadcastMessage table.

### EXAMPLE 2
```
Get-D365BroadcastMessage -ExcludeExpired
```

This will display all active the broadcast message records from the SysBroadcastMessage table.

## PARAMETERS

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

### -ExcludeExpired
Exclude all the records that has already expired

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Broadcast, Message, SysBroadcastMessage, Servicing, Message, Users, Environment

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
