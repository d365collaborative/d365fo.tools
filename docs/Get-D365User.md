---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365User

## SYNOPSIS
Get users from the environment

## SYNTAX

```
Get-D365User [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>]
 [[-Email] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get all relevant user details from the Dynamics 365 for Finance & Operations

## EXAMPLES

### EXAMPLE 1
```
Get-D365User
```

This will get all users from the environment

### EXAMPLE 2
```
Get-D365User -Email "*contoso.com"
```

This will search for all users with an e-mail address containing 'contoso.com' from the environment

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
The password for the SQL Server user.

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

### -Email
The search string to select which user(s) should be updated.

The parameter supports wildcards.
E.g.
-Email "*@contoso.com*"

Default value is "*" to get all users

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: User, Users

Author: Mötz Jensen (@Splaxi)
Author: Rasmus Andersen (@ITRasmus)

## RELATED LINKS
