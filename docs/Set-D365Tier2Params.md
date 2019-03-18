---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365Tier2Params

## SYNOPSIS
Save hashtable with parameters

## SYNTAX

```
Set-D365Tier2Params [-InputObject] <Hashtable> [-ConfigStorageLocation <String>] [-Temporary]
 [<CommonParameters>]
```

## DESCRIPTION
Saves the hashtable as a json string into the configuration store

This cmdlet is only intended to be used for New-D365Bacpac and Import-D365Bacpac for Tier2 environments

## EXAMPLES

### EXAMPLE 1
```
$params = @{ SqlUser = "sqladmin"
```

PS C:\\\> SqlPwd = "pass@word1"
PS C:\\\> }
PS C:\\\> Set-D365Tier2Params -InputObject $params

## PARAMETERS

### -InputObject
The hashtable containing all the parameters you want to store

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
Position: Named
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
