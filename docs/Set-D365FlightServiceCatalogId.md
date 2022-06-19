---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365FlightServiceCatalogId

## SYNOPSIS
Set the FlightingServiceCatalogID

## SYNTAX

```
Set-D365FlightServiceCatalogId [[-FlightServiceCatalogId] <String>] [[-AosServiceWebRootPath] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Set the FlightingServiceCatalogID element in the web.config file used by D365FO

## EXAMPLES

### EXAMPLE 1
```
Set-D365FlightServiceCatalogId
```

This will set the FlightingServiceCatalogID element the web.config to the default value "12719367".

## PARAMETERS

### -FlightServiceCatalogId
Flighting catalog ID to be set

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 12719367
Accept pipeline input: False
Accept wildcard characters: False
```

### -AosServiceWebRootPath
Path to the root folder where to locate the web.config file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

Author: Frank Hüther(@FrankHuether))

The DataAccess.FlightingServiceCatalogID element must already exist in the web.config file, which is expected to be the case in newer environments.
https://docs.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages#features-flighted-in-data-management-and-enabling-flighted-features

## RELATED LINKS
