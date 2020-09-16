---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365SqlScript

## SYNOPSIS
Execute a SQL Script or a SQL Command

## SYNTAX

### FilePath
```
Invoke-D365SqlScript [-FilePath] <String> [-DatabaseServer <String>] [-DatabaseName <String>]
 [-SqlUser <String>] [-SqlPwd <String>] [-TrustedConnection <Boolean>] [-EnableException] [<CommonParameters>]
```

### Command
```
Invoke-D365SqlScript [-Command] <String> [-DatabaseServer <String>] [-DatabaseName <String>]
 [-SqlUser <String>] [-SqlPwd <String>] [-TrustedConnection <Boolean>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Execute a SQL Script or a SQL Command against the D365FO SQL Server database

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SqlScript -FilePath "C:\temp\d365fo.tools\DeleteUser.sql"
```

This will execute the "C:\temp\d365fo.tools\DeleteUser.sql" against the registered SQL Server on the machine.

### EXAMPLE 2
```
Invoke-D365SqlScript -Command "DELETE FROM SALESTABLE WHERE RECID = 123456789"
```

This will execute "DELETE FROM SALESTABLE WHERE RECID = 123456789" against the registered SQL Server on the machine.

## PARAMETERS

### -FilePath
Path to the file containing the SQL Script that you want executed

```yaml
Type: String
Parameter Sets: FilePath
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Command
SQL command that you want executed

```yaml
Type: String
Parameter Sets: Command
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### -TrustedConnection
Switch to instruct the cmdlet whether the connection should be using Windows Authentication or not

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@splaxi)

Author: Caleb Blanchard (@daxcaleb)

## RELATED LINKS
