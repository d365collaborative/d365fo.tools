---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365ExposedService

## SYNOPSIS
Returns Exposed services

## SYNTAX

```
Get-D365ExposedService [-ClientId] <String> [-ClientSecret] <String> [[-D365FO] <String>]
 [[-Authority] <String>] [<CommonParameters>]
```

## DESCRIPTION
Function for getting which services there are exposed from D365

## EXAMPLES

### EXAMPLE 1
```
Get-D365ExposedService -ClientId "MyClientId" -ClientSecret "MyClientSecret"
```

This will show a list of all the services that the D365FO instance is exposing.

## PARAMETERS

### -ClientId
Client Id from the AppRegistration

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

### -ClientSecret
Client Secret from the AppRegistration

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -D365FO
Url fro the D365 including Https://

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Authority
The Authority to issue the token

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES
Tags: DMF, OData, RestApi, Data Management Framework

Author: Rasmus Andersen (@ITRasmus)

Idea taken from http://www.ksaelen.be/wordpresses/dynamicsaxblog/2016/01/dynamics-ax-7-tip-what-services-are-exposed/

## RELATED LINKS
