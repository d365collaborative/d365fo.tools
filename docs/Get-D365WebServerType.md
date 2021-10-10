---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365WebServerType

## SYNOPSIS
Get the default web server to be used

## SYNTAX

```
Get-D365WebServerType [<CommonParameters>]
```

## DESCRIPTION
Get the web server which will be used to run D365FO: Either IIS or IIS Express.
Newly deployed development machines will have this set to IIS Express by default.

It will look for the file located in the default Package Directory.

## EXAMPLES

### EXAMPLE 1
```
Get-D365WebServerType
```

This will display the current web server type registered in the "DynamicsDevConfig.xml" file.
Located in "K:\AosService\PackagesLocalDirectory\bin".

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tag: Web Server, IIS, IIS Express, Development

Author: Sander Holvoet (@smholvoet)

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
