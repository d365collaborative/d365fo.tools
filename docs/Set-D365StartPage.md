---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365StartPage

## SYNOPSIS
Sets the start page in internet explorer

## SYNTAX

### Default (Default)
```
Set-D365StartPage [-Name] <String> [<CommonParameters>]
```

### Url
```
Set-D365StartPage [-Url] <String> [<CommonParameters>]
```

## DESCRIPTION
Function for setting the start page in internet explorer

## EXAMPLES

### EXAMPLE 1
```
Set-D365StartPage -Name 'Demo1'
```

This will update the start page for the current user to "https://Demo1.cloud.onebox.dynamics.com"

### EXAMPLE 2
```
Set-D365StartPage -URL "https://uat.sandbox.operations.dynamics.com"
```

This will update the start page for the current user to "https://uat.sandbox.operations.dynamics.com"

## PARAMETERS

### -Name
Name of the D365 Instance

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
URL of the D365 for Finance & Operations instance that you want to have as your start page

```yaml
Type: String
Parameter Sets: Url
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Rasmus Andersen (@ITRasmus)
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
