---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Import-D365AadUser

## SYNOPSIS
Used to import Aad users into D365FO

## SYNTAX

### UserListImport (Default)
```
Import-D365AadUser [-Users] <String[]> [[-StartupCompany] <String>] [[-DatabaseServer] <String>]
 [[-DatabaseName] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>] [[-IdPrefix] <String>]
 [[-NameSuffix] <String>] [[-IdValue] <String>] [[-NameValue] <String>] [[-AzureAdCredential] <PSCredential>]
 [-SkipAzureAd] [[-EmailValue] <String>] [[-TenantId] <String>] [<CommonParameters>]
```

### GroupNameImport
```
Import-D365AadUser [-AadGroupName] <String> [[-StartupCompany] <String>] [[-DatabaseServer] <String>]
 [[-DatabaseName] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>] [[-IdPrefix] <String>]
 [[-NameSuffix] <String>] [[-IdValue] <String>] [[-NameValue] <String>] [[-AzureAdCredential] <PSCredential>]
 [-ForceExactAadGroupName] [[-EmailValue] <String>] [[-TenantId] <String>] [<CommonParameters>]
```

### GroupIdImport
```
Import-D365AadUser [[-StartupCompany] <String>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [[-IdPrefix] <String>] [[-NameSuffix] <String>]
 [[-IdValue] <String>] [[-NameValue] <String>] [[-AzureAdCredential] <PSCredential>] [-AadGroupId] <String>
 [[-EmailValue] <String>] [[-TenantId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Provides a method for importing a AAD UserGroup or a comma separated list of AadUsers into D365FO.

## EXAMPLES

### EXAMPLE 1
```
Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com"
```

Imports Claire and Allen as users

### EXAMPLE 2
```
$myPassword = ConvertTo-SecureString "MyPasswordIsSecret" -AsPlainText -Force
```

PS C:\\\> $myCredentials = New-Object System.Management.Automation.PSCredential ("MyEmailIsAlso", $myPassword)

PS C:\\\> Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com" -AzureAdCredential $myCredentials

This will import Claire and Allen as users.

### EXAMPLE 3
```
Import-D365AadUser -AadGroupName "CustomerTeam1"
```

if more than one group match the AadGroupName, you can use the ExactAadGroupName parameter
Import-D365AadUser -AadGroupName "CustomerTeam1" -ForceExactAadGroupName

### EXAMPLE 4
```
Import-D365AadUser -AadGroupName "CustomerTeam1" -ForceExactAadGroupName
```

This is used to force the cmdlet to find the exact named group in Azure Active Directory.

### EXAMPLE 5
```
Import-D365AadUser -AadGroupId "99999999-aaaa-bbbb-cccc-9999999999"
```

Imports all the users that is present in the AAD Group called CustomerTeam1

### EXAMPLE 6
```
Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com" -SkipAzureAd
```

Imports Claire and Allen as users.
Will NOT make you connect to the Azure Active Directory(AAD).
The needed details will be based on the e-mail address only, and the rest will be blanked.

### EXAMPLE 7
```
Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com" -TenantId "99999999-aaaa-bbbb-cccc-9999999999"
```

Imports Claire and Allen as users.
Uses tenant id "99999999-aaaa-bbbb-cccc-9999999999"
when connecting to Azure Active Directory(AAD).

## PARAMETERS

### -AadGroupName
Azure Active directory user group containing users to be imported

```yaml
Type: String
Parameter Sets: GroupNameImport
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Users
Array of users that you want to import into the D365FO environment

```yaml
Type: String[]
Parameter Sets: UserListImport
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
Available options 'Login' / 'FirstName' / 'UserPrincipalName'

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

### -SkipAzureAd
Switch to instruct the cmdlet to skip validating against the Azure Active Directory

```yaml
Type: SwitchParameter
Parameter Sets: UserListImport
Aliases:

Required: False
Position: 13
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForceExactAadGroupName
Force to find the exact name of the Azure Active Directory Group

```yaml
Type: SwitchParameter
Parameter Sets: GroupNameImport
Aliases:

Required: False
Position: 14
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AadGroupId
Azure Active directory user group ID containing users to be imported

```yaml
Type: String
Parameter Sets: GroupIdImport
Aliases:

Required: True
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailValue
Specify which field to use as EMAIL value when importing the users.
Available options 'Mail' / 'UserPrincipalName'

Default is 'Mail'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: Mail
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
Position: 17
Default value: $Script:TenantId
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: User, Users, Security, Configuration, Permission, AAD, Azure Active Directory, Group, Groups

Author: Rasmus Andersen (@ITRasmus)
Author: Charles Colombel (@dropshind)
Author: Mötz Jensen (@Splaxi)
Author: Miklós Molnár (@scifimiki)
Author: Gert Van der Heyden (@gertvdh)
Author: Florian Hopfner (@FH-Inway)

At no circumstances can this cmdlet be used to import users into a PROD environment.

Only users from an Azure Active Directory that you have access to, can be imported.
Use AAD B2B implementation if you want to support external people.

Every imported users will get the System Administration / Administrator role assigned on import

## RELATED LINKS
