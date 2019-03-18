---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365Admin

## SYNOPSIS
Powershell implementation of the AdminProvisioning tool

## SYNTAX

```
Set-D365Admin [-AdminSignInName] <String> [[-DatabaseServer] <String>] [[-DatabaseName] <String>]
 [[-SqlUser] <String>] [[-SqlPwd] <String>] [<CommonParameters>]
```

## DESCRIPTION
Cmdlet using the AdminProvisioning tool from D365FO

## EXAMPLES

### EXAMPLE 1
```
Set-D365Admin "claire@contoso.com"
```

This will provision claire@contoso.com as administrator for the environment

## PARAMETERS

### -AdminSignInName
Email for the Admin

```yaml
Type: String
Parameter Sets: (All)
Aliases: Email

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseServer
Alternative SQL Database server, Default is the one provided by the DataAccess object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:DatabaseServer
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Alternative SQL Database, Default is the one provided by the DataAccess object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:DatabaseName
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlUser
Alternative SQL user, Default is the one provided by the DataAccess object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:DatabaseUserName
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlPwd
Alternative SQL user password, Default is the one provided by the DataAccess object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
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
