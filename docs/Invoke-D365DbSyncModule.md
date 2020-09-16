---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365DbSyncModule

## SYNOPSIS
Synchronize all sync base and extension elements based on a modulename

## SYNTAX

```
Invoke-D365DbSyncModule [-Module] <String[]> [[-Verbosity] <String>] [[-BinDirTools] <String>]
 [[-MetadataDir] <String>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [[-LogPath] <String>] [-ShowOriginalProgress] [-OutputCommandOnly] [<CommonParameters>]
```

## DESCRIPTION
Retrieve the list of installed packages / modules where the name fits the ModelName parameter.

It will run loop over the list and start the sync process against all tables, views, data entities, table-extensions,
view-extensions and data entities-extensions of every iterated model

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365DbSyncModule -Module "MyModel1"
```

It will start the sync process against all tables, views, data entities, table-extensions, view-extensions and data entities-extensions of MyModel1.

### EXAMPLE 2
```
Invoke-D365DbSyncModule -Module "MyModel1","MyModel2"
```

It will run loop over the list and start the sync process against all tables, views, data entities, table-extensions, view-extensions and data entities-extensions of every iterated model.

### EXAMPLE 3
```
Get-D365Module -Name "MyModel*" | Invoke-D365DbSyncModule
```

Retrieve the list of installed packages / modules where the name fits the search "MyModel*".

The result is:
MyModel1
MyModel2

It will run loop over the list and start the sync process against all tables, views, data entities, table-extensions, view-extensions and data entities-extensions of every iterated model.

## PARAMETERS

### -Module
Name of the model you want to sync tables and table extensions

Supports an array of module names

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: ModuleName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
Position: 2
Default value: Normal
Accept pipeline input: False
Accept wildcard characters: False
```

### -BinDirTools
Path to where the tools on the machine can be found

Default value is normally the AOS Service PackagesLocalDirectory\bin

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
Default value: $Script:MetaDataDir
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
The path where the log file will be saved

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

Author: Jasper Callens - Cegeka

Author: Caleb Blanchard (@daxcaleb)

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
