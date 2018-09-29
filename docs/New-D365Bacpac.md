---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# New-D365Bacpac

## SYNOPSIS
Generate a bacpac file from a database

## SYNTAX

### ExportTier2 (Default)
```
New-D365Bacpac [-ExportModeTier2] [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [-SqlUser] <String>
 [-SqlPwd] <String> [[-BackupDirectory] <String>] [[-NewDatabaseName] <String>] [[-BacpacFile] <String>]
 [[-CustomSqlFile] <String>] [-ExportOnly] [<CommonParameters>]
```

### ExportTier1
```
New-D365Bacpac [-ExportModeTier1] [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [[-BackupDirectory] <String>] [[-NewDatabaseName] <String>] [[-BacpacFile] <String>]
 [[-CustomSqlFile] <String>] [-ExportOnly] [<CommonParameters>]
```

## DESCRIPTION
Takes care of all the details and steps that is needed to create a valid bacpac file to move between Tier 1 (onebox or Azure hosted) and Tier 2 (MS hosted), or vice versa

Supports to create a raw bacpac file without prepping.
Can be used to automate backup from Tier 2 (MS hosted) environment

## EXAMPLES

### EXAMPLE 1
```
New-D365Bacpac -ExecutionMode FromSql -DatabaseServer localhost -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1
```

Will backup and restore the db database again the localhost server.
Will run the prepping process against the restored database.
Will export a bacpac file.
Will delete the restored database.

### EXAMPLE 2
```
New-D365Bacpac -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1
```

Will create a copy the db database on the dbserver1 in Azure.
Will run the prepping process against the copy database.
Will export a bacpac file.
Will delete the copy database.

### EXAMPLE 3
```
New-D365Bacpac -ExecutionMode FromAzure -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1
```

Normally used for a Tier-2 export and preparation for Tier-1 import

Will create a copy the registered D365 database on the registered D365 Azure SQL Server.
Will run the prepping process against the copy database.
Will export a bacpac file.
Will delete the copy database.

### EXAMPLE 4
```
New-D365Bacpac -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1 -RawBacpacOnly
```

Will export a bacpac file.
The bacpac should be able to restore back into the database without any preparing because it is coming from the environment from the beginning

## PARAMETERS

### -ExportModeTier1
{{Fill ExportModeTier1 Description}}

```yaml
Type: SwitchParameter
Parameter Sets: ExportTier1
Aliases:

Required: True
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportModeTier2
{{Fill ExportModeTier2 Description}}

```yaml
Type: SwitchParameter
Parameter Sets: ExportTier2
Aliases:

Required: True
Position: 1
Default value: False
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
Parameter Sets: ExportTier2
Aliases:

Required: True
Position: 4
Default value: $Script:DatabaseUserName
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ExportTier1
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
Parameter Sets: ExportTier2
Aliases:

Required: True
Position: 5
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ExportTier1
Aliases:

Required: False
Position: 5
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackupDirectory
The path where to store the temporary backup file when the script needs to handle that

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: C:\Temp\d365fo.tools\SqlBackups
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewDatabaseName
The name for the database the script is going to create when doing the restore process

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: "$Script:DatabaseName`_export"
Accept pipeline input: False
Accept wildcard characters: False
```

### -BacpacFile
{{Fill BacpacFile Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: False
Position: 8
Default value: "C:\Temp\d365fo.tools\$DatabaseName.bacpac"
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomSqlFile
{{Fill CustomSqlFile Description}}

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

### -ExportOnly
{{Fill ExportOnly Description}}

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
