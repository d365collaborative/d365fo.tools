---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Import-D365Dacpac

## SYNOPSIS
Import dacpac file to a database

## SYNTAX

```
Import-D365Dacpac [-Path] <String> [[-ModelFile] <String>] [[-PublishFile] <String>]
 [[-DiagnosticFile] <String>] [[-MaxParallelism] <Int32>] [[-DatabaseServer] <String>]
 [[-DatabaseName] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>] [[-LogPath] <String>]
 [-ShowOriginalProgress] [-OutputCommandOnly] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Import a dacpac file into a database, using the publish feature of SqlPackage.exe

If the database doesn't exists, it will be created

If the database exists, the publish process from the dacpac file will make sure to align the different tables inside the database

## EXAMPLES

### EXAMPLE 1
```
Import-D365Dacpac -Path "c:\Temp\AxDB.dacpac" -ModelFile "c:\Temp\dbo.salestable.model.xml"
```

This will import the dacpac file and use the modified model file while doing so.
It will use the "c:\Temp\AxDB.dacpac" as the Path parameter.
It will use the "c:\Temp\dbo.salestable.model.xml" as the ModelFile parameter.

This is used to enable single table restore / publish.

### EXAMPLE 2
```
Import-D365Dacpac -Path "c:\Temp\AxDB.dacpac" -ModelFile "c:\Temp\dbo.salestable.model.xml" -DiagnosticFile "C:\temp\ImportLog.txt" -MaxParallelism 32
```

This will import the dacpac file and use the modified model file while doing so.
It will use the "c:\Temp\AxDB.dacpac" as the Path parameter.
It will use the "c:\Temp\dbo.salestable.model.xml" as the ModelFile parameter.
It will use the "C:\temp\ImportLog.txt" as the DiagnosticFile parameter, where the diagnostic file will be stored.

It will use 32 connections against the database server while importing the bacpac file.

This is used to enable single table restore / publish.

### EXAMPLE 3
```
Import-D365Dacpac -Path "c:\Temp\AxDB.dacpac" -PublishFile "c:\Temp\publish.xml"
```

This will import the dacpac file and use the Publish file which contains advanced configuration instructions for SqlPackage.exe.
It will use the "c:\Temp\AxDB.dacpac" as the Path parameter.
It will use the "c:\Temp\publish.xml" as the PublishFile parameter, which contains advanced configuration instructions for SqlPackage.exe.

This is used to enable full restore / publish, but to avoid some of the common pitfalls.

## PARAMETERS

### -Path
Path to the dacpac file that you want to import

```yaml
Type: String
Parameter Sets: (All)
Aliases: File, Dacpac

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModelFile
Path to the model file that you want the SqlPackage.exe to use instead the one being part of the dacpac file

This is used to override SQL Server options, like collation and etc

This is also used to support single table import / restore from a dacpac file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PublishFile
Path to the publish / profile file that contains extended parameters for the SqlPackage.exe assembly

```yaml
Type: String
Parameter Sets: (All)
Aliases: ProfileFile

Required: False
Position: 3
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
Position: 4
Default value: None
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
Position: 5
Default value: 8
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
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
Default value: $Script:DatabaseUserPassword
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
Position: 10
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\ImportDacpac")
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
Tags: Database, Dacpac, Tier1, Tier2, Golden Config, Config, Configuration

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
