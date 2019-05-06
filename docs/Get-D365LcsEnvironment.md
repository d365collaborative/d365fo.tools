---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsEnvironment

## SYNOPSIS
Get lcs environment

## SYNTAX

```
Get-D365LcsEnvironment [[-Name] <String>] [-OutputAsHashtable] [<CommonParameters>]
```

## DESCRIPTION
Get all lcs environment objects from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsEnvironment
```

This will display all lcs environments on the machine.

### EXAMPLE 2
```
Get-D365LcsEnvironment -OutputAsHashtable
```

This will display all lcs environments on the machine.
Every object will be output as a hashtable, for you to utilize as parameters for other cmdlets.

### EXAMPLE 3
```
Get-D365LcsEnvironment -Name "UAT"
```

This will display the lcs environment that is saved with the name "UAT" on the machine.

## PARAMETERS

### -Name
The name of the lcs environment you are looking for

Default value is "*" to display all lcs environments

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
## NOTES
Tags: Servicing, Environment, Config, Configuration

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Get-D365LcsAssetValidationStatus]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

