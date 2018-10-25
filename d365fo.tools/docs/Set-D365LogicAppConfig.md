---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365LogicAppConfig

## SYNOPSIS
Set the details for the logic app invoke cmdlet

## SYNTAX

```
Set-D365LogicAppConfig [-Url] <String> [-Email] <String> [-Subject] <String>
 [[-ConfigStorageLocation] <String>] [-Temporary] [<CommonParameters>]
```

## DESCRIPTION
Store the needed details for the module to execute an Azure Logic App using a HTTP request

## EXAMPLES

### EXAMPLE 1
```
Set-D365LogicAppConfig -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/
```

This will set all the details about invoking the Logic App.

### EXAMPLE 2
```
Set-D365LogicAppConfig -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/ -ConfigStorageLocation "System"
```

This will set all the details about invoking the Logic App.
The data will be stored in the system wide configuration storage, which makes it accessible from all users.

### EXAMPLE 3
```
Set-D365LogicAppConfig -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/ -Temporary
```

This will set all the details about invoking the Logic App.
The update will only last for the rest of this PowerShell console session.

## PARAMETERS

### -Url
The URL for the http request endpoint of the desired
logic app

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
The receiving email address that should be notified

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

### -Subject
The subject of the email that you want to send

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

### -ConfigStorageLocation
Parameter used to instruct where to store the configuration objects

The default value is "User" and this will store all configuration for the active user

Valid options are:
"User"
"System"

"System" will store the configuration so all users can access the configuration objects

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -Temporary
Switch to instruct the cmdlet to only temporarily override the persisted settings in the configuration storage

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
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
