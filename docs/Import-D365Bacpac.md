---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Import-D365Bacpac

## SYNOPSIS
Import a bacpac file

## SYNTAX

### ImportTier1 (Default)
```
Import-D365Bacpac [-ImportModeTier1] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [-BacpacFile] <String> [-NewDatabaseName] <String>
 [-CustomSqlFile <String>] [-ModelFile <String>] [-DiagnosticFile <String>] [-ImportOnly]
 [-MaxParallelism <Int32>] [-LogPath <String>] [-ShowOriginalProgress] [-OutputCommandOnly] [-EnableException]
 [-Properties <String[]>] [<CommonParameters>]
```

### ImportOnlyTier2
```
Import-D365Bacpac [-ImportModeTier2] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [-SqlUser] <String> [-SqlPwd] <String> [-BacpacFile] <String> [-NewDatabaseName] <String>
 [[-AxDeployExtUserPwd] <String>] [[-AxDbAdminPwd] <String>] [[-AxRuntimeUserPwd] <String>]
 [[-AxMrRuntimeUserPwd] <String>] [[-AxRetailRuntimeUserPwd] <String>] [[-AxRetailDataSyncUserPwd] <String>]
 [[-AxDbReadonlyUserPwd] <String>] [-CustomSqlFile <String>] [-ModelFile <String>] [-DiagnosticFile <String>]
 [-ImportOnly] [-MaxParallelism <Int32>] [-LogPath <String>] [-ShowOriginalProgress] [-OutputCommandOnly]
 [-EnableException] [-Properties <String[]>] [<CommonParameters>]
```

### ImportTier2
```
Import-D365Bacpac [-ImportModeTier2] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [-SqlUser] <String> [-SqlPwd] <String> [-BacpacFile] <String> [-NewDatabaseName] <String>
 [-AxDeployExtUserPwd] <String> [-AxDbAdminPwd] <String> [-AxRuntimeUserPwd] <String>
 [-AxMrRuntimeUserPwd] <String> [-AxRetailRuntimeUserPwd] <String> [-AxRetailDataSyncUserPwd] <String>
 [-AxDbReadonlyUserPwd] <String> [-CustomSqlFile <String>] [-ModelFile <String>] [-DiagnosticFile <String>]
 [-MaxParallelism <Int32>] [-LogPath <String>] [-ShowOriginalProgress] [-OutputCommandOnly] [-EnableException]
 [-Properties <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Import a bacpac file to either a Tier1 or Tier2 environment

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365InstallSqlPackage
```

You should always install the latest version of the SqlPackage.exe, which is used by New-D365Bacpac.

This will fetch the latest .Net Core Version of SqlPackage.exe and install it at "C:\temp\d365fo.tools\SqlPackage".

### EXAMPLE 2
```
Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase"
```

PS C:\\\> Switch-D365ActiveDatabase -NewDatabaseName "ImportedDatabase"

This will instruct the cmdlet that the import will be working against a SQL Server instance.
It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
The next thing to do is to switch the active database out with the new one you just imported.
"ImportedDatabase" will be switched in as the active database, while the old one will be named "AXDB_original".

### EXAMPLE 3
```
Import-D365Bacpac -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd "XyzXyz" -BacpacFile "C:\temp\uat.bacpac" -AxDeployExtUserPwd "XxXx" -AxDbAdminPwd "XxXx" -AxRuntimeUserPwd "XxXx" -AxMrRuntimeUserPwd "XxXx" -AxRetailRuntimeUserPwd "XxXx" -AxRetailDataSyncUserPwd "XxXx" -AxDbReadonlyUserPwd "XxXx" -NewDatabaseName "ImportedDatabase"
```

PS C:\\\> Switch-D365ActiveDatabase -NewDatabaseName "ImportedDatabase" -SqlUser "sqladmin" -SqlPwd "XyzXyz"

This will instruct the cmdlet that the import will be working against an Azure DB instance.
It requires all relevant passwords from LCS for all the builtin user accounts used in a Tier 2 environment.
It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
The next thing to do is to switch the active database out with the new one you just imported.
"ImportedDatabase" will be switched in as the active database, while the old one will be named "AXDB_original".

### EXAMPLE 4
```
Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase" -DiagnosticFile "C:\temp\ImportLog.txt"
```

This will instruct the cmdlet that the import will be working against a SQL Server instance.
It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
It will output a diagnostic file to "C:\temp\ImportLog.txt".

### EXAMPLE 5
```
Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase" -DiagnosticFile "C:\temp\ImportLog.txt" -MaxParallelism 32
```

This will instruct the cmdlet that the import will be working against a SQL Server instance.
It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
It will output a diagnostic file to "C:\temp\ImportLog.txt".

It will use 32 connections against the database server while importing the bacpac file.

### EXAMPLE 6
```
Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase" -ImportOnly
```

This will instruct the cmdlet that the import will be working against a SQL Server instance.
It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
No cleanup or prepping jobs will be executed, because this is for importing only.

This would be something that you can use when extract a bacpac file from a Tier1 and want to import it into a Tier1.
You would still need to execute the Switch-D365ActiveDatabase cmdlet, to get the newly imported database to be the AXDB database.

### EXAMPLE 7
```
[System.Collections.ArrayList] $PropertiesList = New-Object -TypeName "System.Collections.ArrayList"
```

PS C:\\\> $PropertiesList.Add("DisableIndexesForDataPhase=false")
PS C:\\\> Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase" -Properties $PropertiesList.ToArray()

This will instruct the cmdlet that the import will be working against a SQL Server instance.
It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
It will use the DisableIndexesForDataPhase SQLPackage property to disable the index rebuild during the data phase of the import.

## PARAMETERS

### -ImportModeTier1
Switch to instruct the cmdlet that it will import into a Tier1 environment

The cmdlet will expect to work against a SQL Server instance

```yaml
Type: SwitchParameter
Parameter Sets: ImportTier1
Aliases:

Required: True
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportModeTier2
Switch to instruct the cmdlet that it will import into a Tier2 environment

The cmdlet will expect to work against an Azure DB instance

```yaml
Type: SwitchParameter
Parameter Sets: ImportOnlyTier2, ImportTier2
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
Parameter Sets: ImportTier1
Aliases:

Required: False
Position: 4
Default value: $Script:DatabaseUserName
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ImportOnlyTier2, ImportTier2
Aliases:

Required: True
Position: 4
Default value: $Script:DatabaseUserName
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlPwd
The password for the SQL Server user

```yaml
Type: String
Parameter Sets: ImportTier1
Aliases:

Required: False
Position: 5
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ImportOnlyTier2, ImportTier2
Aliases:

Required: True
Position: 5
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### -BacpacFile
Path to the bacpac file you want to import into the database server

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NewDatabaseName
Name of the new database that will be created while importing the bacpac file

This will create a new database on the database server and import the content of the bacpac into

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxDeployExtUserPwd
Password that is obtained from LCS

```yaml
Type: String
Parameter Sets: ImportOnlyTier2
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ImportTier2
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxDbAdminPwd
Password that is obtained from LCS

```yaml
Type: String
Parameter Sets: ImportOnlyTier2
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ImportTier2
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxRuntimeUserPwd
Password that is obtained from LCS

```yaml
Type: String
Parameter Sets: ImportOnlyTier2
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ImportTier2
Aliases:

Required: True
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxMrRuntimeUserPwd
Password that is obtained from LCS

```yaml
Type: String
Parameter Sets: ImportOnlyTier2
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ImportTier2
Aliases:

Required: True
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxRetailRuntimeUserPwd
Password that is obtained from LCS

```yaml
Type: String
Parameter Sets: ImportOnlyTier2
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ImportTier2
Aliases:

Required: True
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxRetailDataSyncUserPwd
Password that is obtained from LCS

```yaml
Type: String
Parameter Sets: ImportOnlyTier2
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ImportTier2
Aliases:

Required: True
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxDbReadonlyUserPwd
Password that is obtained from LCS

```yaml
Type: String
Parameter Sets: ImportOnlyTier2
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ImportTier2
Aliases:

Required: True
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomSqlFile
Path to the sql script file that you want the cmdlet to execute against your data after it has been imported

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

### -ModelFile
Path to the model file that you want the SqlPackage.exe to use instead the one being part of the bacpac file

This is used to override SQL Server options, like collation and etc

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

### -DiagnosticFile
Path to where you want the import to output a diagnostics file to assist you in troubleshooting the import

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

### -ImportOnly
Switch to instruct the cmdlet to only import the bacpac into the new database

The cmdlet will create a new database and import the content of the bacpac file into this

Nothing else will be executed

```yaml
Type: SwitchParameter
Parameter Sets: ImportTier1
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: ImportOnlyTier2
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxParallelism
Sets SqlPackage.exe's degree of parallelism for concurrent operations running against a database

The default value is 8

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

### -LogPath
The path where the log file(s) will be saved

When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed

```yaml
Type: String
Parameter Sets: (All)
Aliases: LogDir

Required: False
Position: Named
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\ImportBacpac")
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

### -Properties
String array of properties to be used by SQLPackage.exe
See https://learn.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-import#properties-specific-to-the-import-action for more information.
Note that some properties are already set by the cmdlet, and cannot be overridden.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Database, Bacpac, Tier1, Tier2, Golden Config, Config, Configuration

Author: Rasmus Andersen (@ITRasmus)
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
