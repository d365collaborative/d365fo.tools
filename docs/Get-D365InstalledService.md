---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365InstalledService

## SYNOPSIS
Get installed D365 services

## SYNTAX

```
Get-D365InstalledService [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get installed Dynamics 365 for Finance & Operations services that are installed on the machine

## EXAMPLES

### EXAMPLE 1
```
Get-D365InstalledService
```

This will get all installed services on the machine.

## PARAMETERS

### -Path
Path to the folder that contians the "InstallationRecords" folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:InstallationRecordsDir
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
