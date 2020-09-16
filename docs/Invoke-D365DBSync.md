---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365DbSync

## SYNOPSIS
Invoke the synchronization process used in Visual Studio

## SYNTAX

```
Invoke-D365DbSync [[-BinDirTools] <String>] [[-MetadataDir] <String>] [[-SyncMode] <String>]
 [[-Verbosity] <String>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [[-LogPath] <String>] [-ShowOriginalProgress] [-OutputCommandOnly] [<CommonParameters>]
```

## DESCRIPTION
Uses the sync.exe (engine) to synchronize the database for the environment

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365DBSync
```

This will invoke the sync engine and have it work against the database.

### EXAMPLE 2
```
Invoke-D365DBSync -Verbose
```

This will invoke the sync engine and have it work against the database.
It will output the same level of details that Visual Studio would normally do.

## PARAMETERS

### -BinDirTools
Path to where the tools on the machine can be found

Default value is normally the AOS Service PackagesLocalDirectory\bin

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:BinDirTools
Accept pipeline input: False
Accept wildcard characters: False
```

### -MetadataDir
Path to where the tools on the machine can be found

Default value is normally the AOS Service PackagesLocalDirectory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:MetaDataDir
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyncMode
The sync mode the sync engine will use

Default value is: "FullAll"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: FullAll
Accept pipeline input: False
Accept wildcard characters: False
```

### -Verbosity
Parameter used to instruct the level of verbosity the sync engine has to report back

Default value is: "Normal"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Normal
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
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\DbSync")
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Database, Sync, SyncDB, Synchronization, Servicing

Author: Rasmus Andersen (@ITRasmus)
Author: Mötz Jensen (@Splaxi)

When running the 'FullAll' (default) the command requires an elevated console / Run As Administrator.

## RELATED LINKS
