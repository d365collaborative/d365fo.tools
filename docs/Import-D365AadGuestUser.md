---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Import-D365AadGuestUser

## SYNOPSIS
Used to import Aad guest users into D365FO

## SYNTAX

```
Import-D365AadGuestUser [-Users] <String[]> [[-StartupCompany] <String>] [[-DatabaseServer] <String>]
 [[-DatabaseName] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>] [[-IdPrefix] <String>]
 [[-NameSuffix] <String>] [[-IdValue] <String>] [[-NameValue] <String>] [[-AzureAdCredential] <PSCredential>]
 [[-TenantId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Provides a method for importing a comma separated list of Aad guest users into D365FO.

## EXAMPLES

### EXAMPLE 1
```
Import-D365AadGuestUser -Users "Claire@contoso.com","Allen@contoso.com"
```

Imports Claire and Allen as guest users

### EXAMPLE 2
```
$myPassword = ConvertTo-SecureString "MyPasswordIsSecret" -AsPlainText -Force
```

PS C:\\\> $myCredentials = New-Object System.Management.Automation.PSCredential ("MyEmailIsAlso", $myPassword)

PS C:\\\> Import-D365AadGuestUser -Users "Claire@contoso.com","Allen@contoso.com" -AzureAdCredential $myCredentials

This will import Claire and Allen as guest users.

### EXAMPLE 3
```
Import-D365AadGuestUser -Users "Claire@contoso.com","Allen@contoso.com" -TenantId "99999999-aaaa-bbbb-cccc-9999999999"
```

Imports Claire and Allen as guest users.
Uses tenant id "99999999-aaaa-bbbb-cccc-9999999999"
when connecting to Azure Active Directory(AAD).

## PARAMETERS

### -Users
Array of users that you want to import into the D365FO environment

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartupCompany
Startup company of users imported.

Default is DAT

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: DAT
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
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### -IdPrefix
A text that will be prefixed into the ID field.
E.g.
-IdPrefix "EXT-" will import users and set ID starting with "EXT-..."

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameSuffix
A text that will be suffixed into the NAME field.
E.g.
-NameSuffix "(Contoso)" will import users and append "(Contoso)"" to the NAME

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IdValue
Specify which field to use as ID value when importing the users.
Available options 'Login' / 'FirstName'

Default is 'Login'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: Login
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameValue
Specify which field to use as NAME value when importing the users.
Available options 'FirstName' / 'DisplayName'

Default is 'DisplayName'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: DisplayName
Accept pipeline input: False
Accept wildcard characters: False
```

### -AzureAdCredential
Use a PSCredential object for connecting with AzureAd

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
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
Position: 13
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

At no circumstances can this cmdlet be used to import users into a PROD environment.

Only guest users from an Azure Active Directory that you have access to, can be imported.

Every imported users will get the System Administration / Administrator role assigned on import

## RELATED LINKS
