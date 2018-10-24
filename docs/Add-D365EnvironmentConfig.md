---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Add-D365EnvironmentConfig

## SYNOPSIS
Save an environment config

## SYNTAX

```
Add-D365EnvironmentConfig [-Name] <String> [-URL] <String> [[-SqlUser] <String>] [[-SqlPwd] <String>]
 [[-Company] <String>] [[-TfsUri] <String>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Adds an environment config to the configuration store

## EXAMPLES

### EXAMPLE 1
```
Add-D365EnvironmentConfig -Name "Customer-UAT" -URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com/?cmp=USMF" -Company "DAT"
```

This will add an entry into the list of environments that is stored with the name "Customer-UAT" and with the URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com/?cmp=USMF".
The company is registered "DAT".

### EXAMPLE 2
```
Add-D365EnvironmentConfig -Name "Customer-UAT" -URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com/?cmp=USMF" -Company "DAT" -SqlUser "SqlAdmin" -SqlPwd "Pass@word1"
```

This will add an entry into the list of environments that is stored with the name "Customer-UAT" and with the URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com/?cmp=USMF".
It will register the SqlUser as "SqlAdmin" and the SqlPassword to "Pass@word1".

This it useful for working on Tier 2 environments where the SqlUser and SqlPassword cannot be extracted from the environment itself.

## PARAMETERS

### -Name
The logical name of the environment you are about to registered in the configuration

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

### -URL
The URL to the environment you want the module to use when possible

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

### -SqlUser
The login name for the SQL Server instance

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Sqladmin
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlPwd
The password for the SQL Server user

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

### -Company
The company you want to work against when calling any browser based cmdlets

The default value is "DAT"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: DAT
Accept pipeline input: False
Accept wildcard characters: False
```

### -TfsUri
The URI for the TFS / VSTS account that you are working against.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Switch to instruct the cmdlet to overwrite already registered environment entry

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
You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.

## RELATED LINKS
