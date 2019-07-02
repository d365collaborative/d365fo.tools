---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Import-D365ExternalUser

## SYNOPSIS
Import an user from an external Azure Active Directory (AAD)

## SYNTAX

```
Import-D365ExternalUser [-Id] <String> [-Name] <String> [-Email] <String> [[-Enabled] <Int32>]
 [[-Company] <String>] [[-Language] <String>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [<CommonParameters>]
```

## DESCRIPTION
Imports an user from an AAD that is NOT the same as the AAD tenant that the D365FO environment is running under

## EXAMPLES

### EXAMPLE 1
```
Import-D365ExternalUser -Id "John" -Name "John Doe" -Email "John@contoso.com"
```

This will import an user from an external Azure Active Directory.
The new user will get the system wide Id "John".
The name of the new user will be "John Doe".
The e-mail address / sign-in e-mail address will be registered as "John@contoso.com".

## PARAMETERS

### -Id
The internal Id that the user must be imported with

The Id has to unique across the entire user base

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The display name of the user inside the D365FO environment

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
The email address of the user that you want to import

This is also the sign-in user name / e-mail address to gain access to the system

If the external AAD tenant has multiple custom domain names, you have to use the domain that they have configured as default

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Should the imported user be enabled or not?

Default value is 1, which equals true / yes

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Company
Default company that should be configured for the user, for when they sign-in to the D365 environment

Default value is "DAT"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: DAT
Accept pipeline input: False
Accept wildcard characters: False
```

### -Language
Language that should be configured for the user, for when they sign-in to the D365 environment

Default value is "en-US"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: En-us
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
Position: 7
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
Position: 8
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
Position: 9
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
Position: 10
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
Tags: User, Users, Security, Configuration, Permission, AAD, Azure Active Directory

Author: Anderson Joyle (@AndersonJoyle)

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
