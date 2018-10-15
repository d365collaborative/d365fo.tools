---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365TfsUri

## SYNOPSIS
Get the TFS / VSTS registered URL / URI

## SYNTAX

```
Get-D365TfsUri [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the URI from the configuration of the local tfs connection in visual studio

## EXAMPLES

### EXAMPLE 1
```
Get-D365TfsUri
```

This will invoke the default tf.exe client located in the Visual Studio 2015 directory
and fetch the configured URI.

## PARAMETERS

### -Path
Path to the tf.exe file that the cmdlet will invoke

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:TfDir
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
