---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365WebConfigDatabase

## SYNOPSIS
Set the database connection details

## SYNTAX

```
Set-D365WebConfigDatabase [-DatabaseServer] <String> [-DatabaseName] <String> [-SqlUser] <String>
 [-SqlPwd] <String> [[-Path] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Overwrite the current database connection details directly in the web.config file

Used when you want to connect a DEV box directly to a Tier2 database, and want to debug something that requires better data than usual

## EXAMPLES

### EXAMPLE 1
```
Set-D365WebConfigDatabase -DatabaseServer TestServer.database.windows.net -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
```

Will overwrite Server, Database, Username and Password directly in the web.config file.
It will save all details unencrypted.

## PARAMETERS

### -DatabaseServer
The name of the database server

Obtain when you request JIT (Just-in-Time) access through the LCS portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
The name of the database

Obtain when you request JIT (Just-in-Time) access through the LCS portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlUser
The login name for the SQL Server instance

Obtain when you request JIT (Just-in-Time) access through the LCS portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlPwd
The password for the SQL Server user

Obtain when you request JIT (Just-in-Time) access through the LCS portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to the web.config file that you want to update with new SQL connection details

Default is: "K:\AosService\WebRoot\web.config" or what else drive that is recognized by the D365FO components as the service drive

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $(Join-Path -Path $Script:AOSPath -ChildPath $Script:WebConfig)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: DEV, Tier2, DB, Database, Debug, JIT, LCS, Azure DB

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
