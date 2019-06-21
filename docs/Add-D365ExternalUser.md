---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Enable-D365User

## SYNOPSIS
Add new user from outside client's AAD (Azure Active Directory)

## SYNTAX

```
Add-D365ExternalUser [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [-Id] <String> [-Name] <String> [-Email] <String> [-SID] <String> [[-Company] <String>] [[-Enabled] <int>] [[-Language] <String>]
```

## DESCRIPTION
Add new user with system user and system administrator role.

The idea behind of this script its to help add partner users into client test/dev environments after a database refresh.

## EXAMPLES

### EXAMPLE 1
```
Add-D365ExternalUser -Id 'newuser' -Name 'My new user' -Email 'newuser@contoso.com' -SID 'S-1-19-...-000000000'
```

This will create a new user.

Following roles will be assigned to new user: System user and system administrator.If user already exists, this script will try to assigned above roles to the user.If user already exists and its assigned to both roles, nothing else will happen.

For the time being, this function does not fetch user's SID. Developers need to have this information in advance.

This examples contains only mandatory parameters.

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


### -Id
New user id

### -Name
New user name

### -Email
New user email address

### -SID
New user SID

### -Company
New user default company

Default value is "DAT"

### -Enabled
New user enabled status

Default value is "true"

### -Language
New user status

Default value is "en-us"

## INPUTS

## OUTPUTS

## NOTES
Tags: User, Users, Security, Configuration, Permission

Author: Anderson Joyle

## RELATED LINKS
