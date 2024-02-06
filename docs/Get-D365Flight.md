---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365Flight

## SYNOPSIS
Used to get a flight

## SYNTAX

```
Get-D365Flight [[-FlightName] <String>] [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [<CommonParameters>]
```

## DESCRIPTION
Provides a method for listing a flight in D365FO.

## EXAMPLES

### EXAMPLE 1
```
Get-D365Flight
```

This will list all flights that are configured on the environment.
It will show the name and the enabled status.

A result set example:

FlightName                         Enabled FlightServiceId
----------                         ------- ---------------
WHSWorkCancelForcedFlight          1       12719367
TAMRebateGlobalEnableFeature       1       12719367
EnablePerfInfoSimpleLoggerV2       1       12719367
EnablePerfInfoLogODataV2           1       12719367
EnablePerfInfoLogEtwRequestTableV2 1       12719367
EnablePerfInfoCursorLayerV2        1       12719367
EnablePerfInfoFormEngineLayerV2    1       12719367
EnablePerfInfoMutexWaitLayerV2     1       12719367
EnablePerfInfoSecurityLayerV2      1       12719367
EnablePerfInfoSessionLayerV2       1       12719367
EnablePerfInfoSQLLayerV2           1       12719367
EnablePerfInfoXppContainerLayerV2  1       12719367

### EXAMPLE 2
```
Get-D365Flight -FlightName WHSWorkCancelForcedFlight
```

This will list the flight with the specified name on the environment.
It will show the name and the enabled status.

A result set example:

FlightName                         Enabled FlightServiceId
----------                         ------- ---------------
WHSWorkCancelForcedFlight          1       12719367

### EXAMPLE 3
```
Get-D365Flight -FlightName WHS*
```

This will list the flight with the specified pattern on the environment.
It will filter the output to match the "WHS*" pattern.
It will show the name and the enabled status.

A result set example:

FlightName                         Enabled FlightServiceId
----------                         ------- ---------------
WHSWorkCancelForcedFlight          1       12719367

## PARAMETERS

### -FlightName
Name of the flight that you are looking for

Supports wildcards "*"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
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
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Flight, Flighting

Author: Mötz Jensen (@Splaxi)

At no circumstances can this cmdlet be used to enable a flight in a PROD environment.

## RELATED LINKS
