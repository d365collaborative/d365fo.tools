---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Remove-D365LcsEnvironment

## SYNOPSIS
Remove lcs environment

## SYNTAX

```
Remove-D365LcsEnvironment [-Name] <String> [-Temporary] [<CommonParameters>]
```

## DESCRIPTION
Remove a lcs environment from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Remove-D365LcsEnvironment -Name "UAT"
```

This will remove the lcs environment named "UAT" from the machine.

## PARAMETERS

### -Name
Name of the lcs environment you want to remove from the configuration store

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

### -Temporary
Instruct the cmdlet to only temporarily remove the lcs environment from the configuration store

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Servicing, Environment, Config, Configuration,

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Get-D365LcsAssetValidationStatus]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

