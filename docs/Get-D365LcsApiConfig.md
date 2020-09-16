---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsApiConfig

## SYNOPSIS
Get the LCS configuration details

## SYNTAX

```
Get-D365LcsApiConfig [-OutputAsHashtable] [<CommonParameters>]
```

## DESCRIPTION
Get the LCS configuration details from the configuration store

All settings retrieved from this cmdlets is to be considered the default parameter values across the different cmdlets

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsApiConfig
```

This will output the current LCS API configuration.
The object returned will be a PSCustomObject.

### EXAMPLE 2
```
Get-D365LcsApiConfig -OutputAsHashtable
```

This will output the current LCS API configuration.
The object returned will be a Hashtable.

## PARAMETERS

### -OutputAsHashtable
Instruct the cmdlet to return a hashtable object

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
Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiToken]()

[Get-D365LcsAssetValidationStatus]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsDeployment]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

