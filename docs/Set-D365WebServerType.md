---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365WebServerType

## SYNOPSIS
Set the web server type to be used to run the D365FO instance

## SYNTAX

```
Set-D365WebServerType [-RuntimeHostType] <String> [<CommonParameters>]
```

## DESCRIPTION
Set the web server which will be used to run D365FO: Either IIS or IIS Express.
Newly deployed development machines will have this set to IIS Express by default.

It will backup the current "DynamicsDevConfig.xml" file, for you to revert the changes if anything should go wrong.

It will look for the file located in the default Package Directory.

## EXAMPLES

### EXAMPLE 1
```
Set-D365WebServerType -RuntimeHostType "IIS"
```

This will update the current web server type registered in the "DynamicsDevConfig.xml" file.
This file is located "K:\AosService\PackagesLocalDirectory\bin".
It will backup the current "DynamicsDevConfig.xml" file.
It will replace the value inside the "RuntimeHostType" tag.

## PARAMETERS

### -RuntimeHostType
The type of web server you want to use.

Valid options are:
"IIS"
"IISExpress"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tag: Web Server, IIS, IIS Express, Development

Author: Sander Holvoet (@smholvoet)

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
