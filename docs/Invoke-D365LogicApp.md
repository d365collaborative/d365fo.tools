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
Invoke-D365LogicApp [[-Url] <String>] [[-Email] <String>] [[-Subject] <String>] [-IncludeAll] [-AsJob]
```

## DESCRIPTION
Invoke a Logic App using a http request and pass a json object with details about the calling function

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SyncDB | Invoke-D365LogicApp
```

This will execute the sync process and when it is done it will invoke a Azure Logic App with the default parameters that have been configured for the system.

### EXAMPLE 2
```
Invoke-D365SyncDB | Invoke-D365LogicApp -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/
```

This will execute the sync process and when it is done it will invoke a Azure Logic App with the email, subject and URL parameters that are needed to invoke an Azure Logic App.

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

### -Email
The email address of the receiver of the message that the cmdlet will send

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Get-D365LogicAppConfig).Email
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
Subject string to apply to the email and to the IM message

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: (Get-D365LogicAppConfig).Subject
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeAll
Switch to instruct the cmdlet to include all cmdlets (names only) from the pipeline

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

### -AsJob
Switch to instruct the cmdlet to run the invocation as a job (async)

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
