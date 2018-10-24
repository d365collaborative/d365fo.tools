---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Remove-D365User

## SYNOPSIS
Delete an user from the environment

## SYNTAX

```
Remove-D365User [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [-Email] <String> [<CommonParameters>]
```

## DESCRIPTION
Deletes the user from the database, including security configuration

## EXAMPLES

### EXAMPLE 1
```
Remove-D365User -Email "Claire@contoso.com"
```

This will move all security and user details from the user with the email address
"Claire@contoso.com"

### EXAMPLE 2
```
Get-D365User -Email *contoso.com | Remove-D365User
```

This will first get all users from the database that matches the *contoso.com
search and pipe their emails to Remove-D365User for it to delete them.

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

You have to specific the explicit email address of the user you want to remove

The cmdlet will not be able to delete the ADMIN user, this is to prevent you
from being locked out of the system.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
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
