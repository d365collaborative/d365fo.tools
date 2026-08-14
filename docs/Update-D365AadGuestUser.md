---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Update-D365AadGuestUser

## SYNOPSIS
Updates the guest user details in the database

## SYNTAX

```
Update-D365AadGuestUser [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [-Email] <String> [[-AzureAdCredential] <PSCredential>] [[-TenantId] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Is capable of updating the identity provider, network domain and object id inside the UserInfo table for AAD guest users

## EXAMPLES

### EXAMPLE 1
```
Update-D365AadGuestUser -Email "claire@contoso.com"
```

This will search for the user with the e-mail address claire@contoso.com and update it with the identity provider, network domain and object id needed for an AAD guest user

### EXAMPLE 2
```
Update-D365AadGuestUser -Email "*contoso.com"
```

This will search for all users with an e-mail address containing 'contoso.com' and update them with the identity provider, network domain and object id needed for an AAD guest user

### EXAMPLE 3
```
Update-D365AadGuestUser -Email "claire@contoso.com" -TenantId "99999999-aaaa-bbbb-cccc-9999999999"
```

This will search for the user with the e-mail address claire@contoso.com and update it with the identity provider, network domain and object id needed for an AAD guest user.
Uses tenant id "99999999-aaaa-bbbb-cccc-9999999999" when connecting to Azure Active Directory(AAD).

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
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AzureAdCredential
Use a PSCredential object for connecting with AzureAd

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId
The TenantId to use when connecting to Azure Active Directory

Uses the tenant id of the current environment if not specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Script:TenantId
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: User, Users, Security, Configuration, Permission, AAD, Azure Active Directory, Guest

Author: Mötz Jensen (@Splaxi)

At no circumstances can this cmdlet be used to update users in a PROD environment.

## RELATED LINKS
