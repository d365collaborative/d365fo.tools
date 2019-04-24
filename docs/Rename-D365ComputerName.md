---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Rename-D365ComputerName

## SYNOPSIS
Function for renaming computer.
Renames Computer and changes the SSRS Configration

## SYNTAX

```
Rename-D365ComputerName [-NewName] <String> [[-SSRSReportDatabase] <String>] [<CommonParameters>]
```

## DESCRIPTION
When doing development on-prem, there is as need for changing the Computername.
Function both changes Computername and SSRS Configuration

## EXAMPLES

### EXAMPLE 1
```
Rename-D365ComputerName -NewName "Demo-8.1" -SSRSReportDatabase "ReportServer"
```

This will rename the local machine to the "Demo-8.1" as the new Windows machine name.
It will update the registration inside the SQL Server Reporting Services configuration to handle the new name of the machine.

## PARAMETERS

### -NewName
The new name for the computer

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

### -SSRSReportDatabase
Name of the SSRS reporting database

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: DynamicsAxReportServer
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Rasmus Andersen (@ITRasmus)
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
