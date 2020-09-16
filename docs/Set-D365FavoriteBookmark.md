---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365FavoriteBookmark

## SYNOPSIS
Enable the favorite bar and add an URL

## SYNTAX

### D365FO (Default)
```
Set-D365FavoriteBookmark [-URL <String>] [-D365FO] [<CommonParameters>]
```

### AzureDevOps
```
Set-D365FavoriteBookmark [-URL <String>] [-AzureDevOps] [<CommonParameters>]
```

## DESCRIPTION
Enable the favorite bar in internet explorer and put in the URL as a favorite

## EXAMPLES

### EXAMPLE 1
```
Set-D365FavoriteBookmark -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com"
```

This will add the "https://usnconeboxax1aos.cloud.onebox.dynamics.com" to the favorite bar, enable the favorite bar and lock it.
This will be interpreted as the using the -D365FO parameter also, because that is the expected behavior.

### EXAMPLE 2
```
Set-D365FavoriteBookmark -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -D365FO
```

This will add the "https://usnconeboxax1aos.cloud.onebox.dynamics.com" to the favorite bar, enable the favorite bar and lock it.
The bookmark will be mapped as the one for the Dynamics 365 Finance & Operations instance.

### EXAMPLE 3
```
Set-D365FavoriteBookmark -Url "https://CUSTOMERNAME.visualstudio.com/" -AzureDevOps
```

This will add the "https://CUSTOMERNAME.visualstudio.com/" to the favorite bar, enable the favorite bar and lock it.
The bookmark will be mapped as the one for the Azure DevOps instance.

### EXAMPLE 4
```
Get-D365Url | Set-D365FavoriteBookmark
```

This will get the URL from the environment and add that to the favorite bar, enable the favorite bar and lock it.
This will be interpreted as the using the -D365FO parameter also, because that is the expected behavior.

## PARAMETERS

### -URL
The URL of the shortcut you want to add to the favorite bar

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -D365FO
Instruct the cmdlet that you want the populate the D365FO favorite entry based on the URL provided

```yaml
Type: SwitchParameter
Parameter Sets: D365FO
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AzureDevOps
Instruct the cmdlet that you want the populate the AzureDevOps favorite entry based on the URL provided

```yaml
Type: SwitchParameter
Parameter Sets: AzureDevOps
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
