---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Test-D365FlightServiceCatalogId

## SYNOPSIS
Test if the FlightingServiceCatalogID is present and filled out

## SYNTAX

```
Test-D365FlightServiceCatalogId [[-AosServiceWebRootPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Test if the FlightingServiceCatalogID element exists in the web.config file used by D365FO

## EXAMPLES

### EXAMPLE 1
```
Test-D365FlightServiceCatalogId
```

This will open the web.config and check if the FlightingServiceCatalogID element is present or not.

## PARAMETERS

### -AosServiceWebRootPath
Path to the root folder where to locate the web.config file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:AOSPath
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Flight, Flighting

Author: Mötz Jensen (@Splaxi))

The DataAccess.FlightingServiceCatalogID must already be set in the web.config file.
https://docs.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages#features-flighted-in-data-management-and-enabling-flighted-features

## RELATED LINKS
