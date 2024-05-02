---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Test-D365DataverseConnection

## SYNOPSIS
Test the dataverse connection

## SYNTAX

```
Test-D365DataverseConnection [[-BinDir] <String>] [<CommonParameters>]
```

## DESCRIPTION
Invokes the built-in http communication endpount, that validates the connection between the D365FO environment and dataverse

## EXAMPLES

### EXAMPLE 1
```
Test-D365DataverseConnection
```

This will invoke the http communication component, that validates the basic settings between D365FO and Dataverse.
It will output the raw details from the call, to make it easier to troubleshoot the connectivity between D365FO and Dataverse.

## PARAMETERS

### -BinDir
The path to the bin directory for the environment

Default path is the same as the aos service PackagesLocalDirectory\bin

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "$Script:BinDir\bin"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
