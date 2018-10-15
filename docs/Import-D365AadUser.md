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
 [<CommonParameters>]
```

### GroupImport
```
Import-D365AadUser [-AadGroupName] <String> [[-StartupCompany] <String>] [[-DatabaseServer] <String>]
 [[-DatabaseName] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>] [[-IdPrefix] <String>]
 [[-NameSuffix] <String>] [[-IdValue] <String>] [[-NameValue] <String>] [[-AzureAdCredential] <PSCredential>]
 [<CommonParameters>]
```

## DESCRIPTION
Provides a method for importing a AAD UserGroup or a comma separated list of AadUsers into D365FO.

## EXAMPLES

### EXAMPLE 1
```
Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com"
```

Imports Claire and Allen as users.

### EXAMPLE 2
```
$myPassword = ConvertTo-SecureString "MyPasswordIsSecret" -AsPlainText -Force
```

$myCredentials = New-Object System.Management.Automation.PSCredential ("MyEmailIsAlso", $myPassword)

Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com" -AzureAdCredential $myCredentials

Imports Claire and Allen as users.

### EXAMPLE 3
```
Import-D365AadUser -AadGroupName "CustomerTeam1"
```

Imports all the users that is present in the AAD Group called CustomerTeam1

## PARAMETERS

### -AadGroupName
Azure Active directory user group containing users to be imported

```yaml
Type: String
Parameter Sets: GroupImport
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Users
{{Fill Users Description}}

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
Alternative SQL Database server, Default is the one provided by the DataAccess object

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
Alternative SQL Database, Default is the one provided by the DataAccess object

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
Alternative SQL user, Default is the one provided by the DataAccess object

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
Alternative SQL user password, Default is the one provided by the DataAccess object

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
At no circumstances can this cmdlet be used to import users into a PROD environment.

Only users from an Azure Active Directory that you have access to, can be imported.
Use AAD B2B implementation if you want to support external people.

Every imported users will get the System Administration / Administrator role assigned on import

## RELATED LINKS
