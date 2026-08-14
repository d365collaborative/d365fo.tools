---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Publish-D365WebResources

## SYNOPSIS
Deploy web resources

## SYNTAX

```
Publish-D365WebResources [[-PackageDirectory] <PathDirectoryParameter>]
 [[-AosServiceWebRootPath] <PathDirectoryParameter>] [<CommonParameters>]
```

## DESCRIPTION
Deploys the Dynamics 365 for Finance and Operations web resources to the AOS service web root path.

## EXAMPLES

### EXAMPLE 1
```
Publish-D365WebResources
```

This will deploy the web resources to the AOS service web root path.

## PARAMETERS

### -PackageDirectory
Path to the package directory containing the web resources.

```yaml
Type: PathDirectoryParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:PackageDirectory
Accept pipeline input: False
Accept wildcard characters: False
```

### -AosServiceWebRootPath
Path to the AOS service web root path.

```yaml
Type: PathDirectoryParameter
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
Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS
