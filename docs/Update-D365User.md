---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Update-D365User

## SYNOPSIS
Updates the user details in the database

## SYNTAX

```
Update-D365User [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [-Email] <String> [[-Company] <String>] [<CommonParameters>]
```

## DESCRIPTION
Is capable of updating all the user details inside the UserInfo table to enable a user to sign in

## EXAMPLES

### EXAMPLE 1
```
Update-D365User -Email "claire@contoso.com"
```

This will search for the user with the e-mail address claire@contoso.com and update it with needed information based on the tenant owner of the environment

### EXAMPLE 2
```
Update-D365User -Email "*contoso.com"
```

This will search for all users with an e-mail address containing 'contoso.com' and update them with needed information based on the tenant owner of the environment

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

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Company
The company the user should start in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Rasmus Andersen (@ITRasmus)
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
