---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365LcsUploadConfig

## SYNOPSIS
Set the LCS configuration details

## SYNTAX

```
Set-D365LcsUploadConfig [[-ProjectId] <Int32>] [[-ClientId] <String>] [[-Username] <String>]
 [[-Password] <String>] [[-LcsApiUri] <String>] [-ConfigStorageLocation <String>] [-Temporary] [-Clear]
 [<CommonParameters>]
```

## DESCRIPTION
Set the LCS configuration details and save them into the configuration store

## EXAMPLES

### EXAMPLE 1
```
Set-D365LcsUploadConfig -ProjectId 123456789 -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username claire@contoso.com -Password "pass@word1" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will save the ProjectId 123456789 and ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" to be default values when using the Invoke-D365LcsUpload cmdlet.
The Username Claire@contoso.com and the Password "pass@word1" will also be stored as default values when using the Invoke-D365LcsUpload cmdlet.
The NON-EUROPE LCS API address will be configured as the endpoint when using the Invoke-D365LcsUpload cmdlet.

## PARAMETERS

### -ProjectId
The project id for the Dynamics 365 for Finance & Operations project inside LCS

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The username of the account that you want to impersonate

It can either be your personal account or a service account

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

### -Password
The password of the account that you want to impersonate

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

### -LcsApiUri
URI / URL to the LCS API you want to use

Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's

Valid options:
"https://lcsapi.lcs.dynamics.com"
"https://lcsapi.eu.lcs.dynamics.com"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: Https://lcsapi.lcs.dynamics.com
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
Instruct the cmdlet to only temporarily override the persisted settings in the configuration storage

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

### -Clear
Instruct the cmdlet to clear out all the stored configuration values

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
Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
