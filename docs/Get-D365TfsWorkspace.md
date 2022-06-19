---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365TfsWorkspace

## SYNOPSIS
Get the TFS / VSTS registered workspace path

## SYNTAX

```
Get-D365TfsWorkspace [[-Path] <String>] [[-TfsUri] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the workspace path from the configuration of the local tfs in visual studio

## EXAMPLES

### EXAMPLE 1
```
Get-D365TfsWorkspace -TfsUri https://PROJECT.visualstudio.com
```

This will invoke the default tf.exe client located in the Visual Studio 2015 directory
and fetch the configured URI.

## PARAMETERS

### -Path
Path to the directory where the Team Foundation Client executable is located

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:TfDir
Accept pipeline input: False
Accept wildcard characters: False
```

### -TfsUri
Uri to the TFS / VSTS that the workspace is connected to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:TfsUri
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: TFS, VSTS, URL, URI, Servicing, Development

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
