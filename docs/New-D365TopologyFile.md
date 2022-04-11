---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# New-D365TopologyFile

## SYNOPSIS
Create a new topology file

## SYNTAX

```
New-D365TopologyFile [-Path] <String> [-Services] <String[]> [-NewPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Build a new topology file based on a template and update the ServiceModelList

## EXAMPLES

### EXAMPLE 1
```
New-D365TopologyFile -Path C:\Temp\DefaultTopologyData.xml -Services "ALMService","AOSService","BIService" -NewPath C:\temp\CurrentTopology.xml
```

This will read the "DefaultTopologyData.xml" file and fill in "ALMService","AOSService" and "BIService"
as the services in the ServiceModelList tag.
The new file is stored at "C:\temp\CurrentTopology.xml"

### EXAMPLE 2
```
$Services = @(Get-D365InstalledService | ForEach-Object {$_.Servicename})

New-D365TopologyFile -Path C:\Temp\DefaultTopologyData.xml -Services $Services -NewPath C:\temp\CurrentTopology.xml
```

This will get all the services already installed on the machine.
Afterwards the list is piped
to New-D365TopologyFile where all services are imported into the new topology file that is stored at "C:\temp\CurrentTopology.xml"

## PARAMETERS

### -Path
Path to the template topology file

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Services
The array with all the service names that you want to fill into the topology file

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewPath
Path to where you want to save the new file after it has been created

```yaml
Type: String
Parameter Sets: (All)
Aliases: NewFile

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
