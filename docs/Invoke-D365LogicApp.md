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
Invoke-D365LogicApp [[-Url] <String>] [[-Email] <String>] [[-Subject] <String>] [-IncludeAll]
```

## DESCRIPTION
Invoke a Logic App using a http request and pass
a json object with details about the calling function

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SyncDB | Invoke-D365LogicApp
```

This will execute the sync process and when it is done
it will invoke a Azure Logic App with the default parameters
that have been configured for the system.

### EXAMPLE 2
```
Invoke-D365SyncDB | Invoke-D365LogicApp -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/
```

This will execute the sync process and when it is done
it will invoke a Azure Logic App with the email, subject and URL 
parameters that are needed to invoke an Azure Logic App

## PARAMETERS

### -Url
{{Fill Url Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $logicApp.Url
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
{{Fill Email Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $logicApp.Email
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
{{Fill Subject Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $logicApp.Subject
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeAll
Parameter description

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

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
