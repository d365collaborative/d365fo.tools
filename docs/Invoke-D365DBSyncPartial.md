---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365DBSyncPartial

## SYNOPSIS
Invoke the synchronization process used in Visual Studio

## SYNTAX

```
Invoke-D365DBSyncPartial [[-SyncMode] <String>] [[-SyncList] <String[]>] [[-SyncExtensionsList] <String[]>] [[-LogPath] <String>]
 [[-Verbosity] <String>] [[-ModelName] <String>] [[-BinDirTools] <String>] [[-MetadataDir] <String>] [[-DatabaseServer] <String>]
 [[-DatabaseName] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>] [-ShowOriginalProgress]
 [-OutputCommandOnly] [<CommonParameters>]
```

## DESCRIPTION
Uses the sync.exe (engine) to synchronize the database for the environment

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365DBSyncPartial -SyncList "CustCustomerEntity","SalesTable"
```

Will sync the "CustCustomerEntity" and "SalesTable" objects in the database.
This will invoke the sync engine and have it work against the database.
It will run with the default value "PartialList" as the SyncMode.
It will run the sync process against "CustCustomerEntity" and "SalesTable"

### EXAMPLE 2
```
Invoke-D365DBSyncPartial -SyncList "CustCustomerEntity","SalesTable" -Verbose
```

Will sync the "CustCustomerEntity" and "SalesTable" objects in the database.
This will invoke the sync engine and have it work against the database.
It will run with the default value "PartialList" as the SyncMode.
It will run the sync process against "CustCustomerEntity" and "SalesTable"

It will output the same level of details that Visual Studio would normally do.

### EXAMPLE 3
```
Invoke-D365DBSyncPartial -ModelName "FleetManagement"
```

Will sync the all base and extension elements from the "FleetManagement" model
This will invoke the sync engine and have it work against the database.
It will run with the default value "PartialList" as the SyncMode.
It will run the sync process against all tables, views, data entities, table-extensions, view-extensions and data entities-extensions of provided model

## PARAMETERS

### -SyncMode
The sync mode the sync engine will use

Default value is: "PartialList"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: PartialList
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyncList
The list of objects that you want to pass on to the database synchronoziation engine

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyncExtensionsList
The list of extension objects that you want to pass on to the database synchronoziation engine

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogPath
The path where the log file will be saved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: C:\temp\D365FO.Tools\Sync
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
Position: 5
Default value: Normal
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModelName
Name of the model you want to sync tables and table extensions

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
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
Position: 10
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
Position: 11
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
Position: 12
Default value: $Script:DatabaseUserPassword
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

Author: Mötz Jensen (@Splaxi)

Inspired by:
https://axdynamx.blogspot.com/2017/10/how-to-synchronize-manually-database.html

## RELATED LINKS
