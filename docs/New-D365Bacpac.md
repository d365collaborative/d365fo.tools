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
 [-SqlPwd] <String> [[-NewDatabaseName] <String>] [[-BacpacFile] <String>] [[-CustomSqlFile] <String>]
 [-DiagnosticFile <String>] [-ExportOnly] [-MaxParallelism <Int32>] [-ShowOriginalProgress]
 [-OutputCommandOnly] [-EnableException] [<CommonParameters>]
```

### ExportTier1
```
New-D365Bacpac [-ExportModeTier1] [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [[-BackupDirectory] <String>] [[-NewDatabaseName] <String>] [[-BacpacFile] <String>]
 [[-CustomSqlFile] <String>] [-DiagnosticFile <String>] [-ExportOnly] [-MaxParallelism <Int32>]
 [-ShowOriginalProgress] [-OutputCommandOnly] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Takes care of all the details and steps that is needed to create a valid bacpac file to move between Tier 1 (onebox or Azure hosted) and Tier 2 (MS hosted), or vice versa

Supports to create a raw bacpac file without prepping.
Can be used to automate backup from Tier 2 (MS hosted) environment

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365InstallSqlPackage
```

You should always install the latest version of the SqlPackage.exe, which is used by New-D365Bacpac.

This will fetch the latest .Net Core Version of SqlPackage.exe and install it at "C:\temp\d365fo.tools\SqlPackage".

### EXAMPLE 2
```
New-D365Bacpac -ExportModeTier1 -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacFile "C:\Temp\Bacpac\Testing1.bacpac"
```

Will backup the "AXDB" database and restore is as "Testing1" again the localhost SQL Server.
Will run the prepping process against the restored database.
Will export a bacpac file to "C:\Temp\Bacpac\Testing1.bacpac".
Will delete the restored database.
It will use trusted connection (Windows authentication) while working against the SQL Server.

### EXAMPLE 3
```
New-D365Bacpac -ExportModeTier2 -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacFile C:\Temp\Bacpac\Testing1.bacpac
```

Will create a copy the db database on the dbserver1 in Azure.
Will run the prepping process against the copy database.
Will export a bacpac file.
Will delete the copy database.

### EXAMPLE 4
```
New-D365Bacpac -ExportModeTier2 -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacFile "C:\Temp\Bacpac\Testing1.bacpac"
```

Normally used for a Tier-2 export and preparation for Tier-1 import

Will create a copy of the registered D365 database on the registered D365 Azure SQL DB instance.
Will run the prepping process against the copy database.
Will export a bacpac file.
Will delete the copy database.

### EXAMPLE 5
```
New-D365Bacpac -ExportModeTier2 -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacFile C:\Temp\Bacpac\Testing1.bacpac -ExportOnly
```

Will export a bacpac file.
The bacpac should be able to restore back into the database without any preparing because it is coming from the environment from the beginning

### EXAMPLE 6
```
New-D365Bacpac -ExportModeTier1 -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacFile "C:\Temp\Bacpac\Testing1.bacpac" -DiagnosticFile "C:\temp\ExportLog.txt"
```

Will backup the "AXDB" database and restore is as "Testing1" again the localhost SQL Server.
Will run the prepping process against the restored database.
Will export a bacpac file to "C:\Temp\Bacpac\Testing1.bacpac".
Will delete the restored database.
It will use trusted connection (Windows authentication) while working against the SQL Server.

It will output a diagnostic file to "C:\temp\ExportLog.txt".

### EXAMPLE 7
```
New-D365Bacpac -ExportModeTier1 -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacFile "C:\Temp\Bacpac\Testing1.bacpac" -MaxParallelism 32
```

Will backup the "AXDB" database and restore is as "Testing1" again the localhost SQL Server.
Will run the prepping process against the restored database.
Will export a bacpac file to "C:\Temp\Bacpac\Testing1.bacpac".
Will delete the restored database.
It will use trusted connection (Windows authentication) while working against the SQL Server.

It will use 32 connections against the database server while generating the bacpac file.

## PARAMETERS

### -ExportModeTier1
Switch to instruct the cmdlet that the export will be done against a classic SQL Server installation

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
Switch to instruct the cmdlet that the export will be done against an Azure SQL DB instance

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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ExportTier1
Aliases:

Required: False
Position: 4
Default value: $Script:DatabaseUserName
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SqlPwd
The password for the SQL Server user

```yaml
Type: String
Parameter Sets: ExportTier2
Aliases:

Required: True
Position: 5
Default value: $Script:DatabaseUserPassword
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ExportTier1
Aliases:

Required: False
Position: 5
Default value: $Script:DatabaseUserPassword
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BackupDirectory
The path where to store the temporary backup file when the script needs to handle that

```yaml
Type: String
Parameter Sets: ExportTier1
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
The path where you want the cmdlet to store the bacpac file that will be generated

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
The path to a custom sql server script file that you want executed against the database before it is exported

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

### -DiagnosticFile
Path to where you want the export to output a diagnostics file to assist you in troubleshooting the export

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportOnly
Switch to instruct the cmdlet to either just create a dump bacpac file or run the prepping process first

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

### -MaxParallelism
Sets SqlPackage.exe's degree of parallelism for concurrent operations running against a database.
The default value is 8.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 8
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowOriginalProgress
Instruct the cmdlet to show the standard output in the console

Default is $false which will silence the standard output

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

### -OutputCommandOnly
Instruct the cmdlet to only output the command that you would have to execute by hand

Will include full path to the executable and the needed parameters based on your selection

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
The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

Author: Rasmus Andersen (@ITRasmus)
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
