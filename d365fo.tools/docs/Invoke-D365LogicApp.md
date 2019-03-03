---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365LogicApp

## SYNOPSIS
Invoke a http request for a Logic App

## SYNTAX

```
Invoke-D365LogicApp [[-Url] <String>] [[-Payload] <String>] [<CommonParameters>]
```

## DESCRIPTION
Invoke a Logic App using a http request and pass a json object with details about the calling function

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SyncDB | Invoke-D365LogicApp
```

This will execute the sync process and when it is done it will invoke a Azure Logic App with the default parameters that have been configured for the system.

## PARAMETERS

### -Url
The URL for the http endpoint that you want to invoke

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-D365LogicAppConfig).Url
Accept pipeline input: False
Accept wildcard characters: False
```

### -Payload
The data content you want to send to the LogicApp

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: {}
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: LogicApp, Logic App, Configuration, Url, Notification

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
