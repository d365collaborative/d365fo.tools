---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsAssetValidationStatus

## SYNOPSIS
Get the validation status from LCS

## SYNTAX

```
Get-D365LcsAssetValidationStatus [-ProjectId <Int32>] [-BearerToken <String>] [-AssetId] <String>
 [-LcsApiUri <String>] [-WaitForValidation] [<CommonParameters>]
```

## DESCRIPTION
Get the validation status for a given file in the Asset Library in LCS

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsAssetValidationStatus -ProjectId 123456789 -BearerToken "JldjfafLJdfjlfsalfd..." -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will check the validation status for the file in the Asset Library.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

### EXAMPLE 2
```
Get-D365LcsAssetValidationStatus -AssetId "958ae597-f089-4811-abbd-c1190917eaae"
```

This will check the validation status for the file in the Asset Library.
The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.

All default values will come from the configuration available from Get-D365LcsApiConfig.

### EXAMPLE 3
```
Get-D365LcsAssetValidationStatus -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -WaitForValidation
```

This will check the validation status for the file in the Asset Library.
The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
The cmdlet will every 60 seconds contact the LCS API endpoint and check if the status of the validation is either success or failure.

All default values will come from the configuration available from Get-D365LcsApiConfig.

### EXAMPLE 4
```
Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" | Get-D365LcsAssetValidationStatus -WaitForValidation
```

This will start the upload of a file to the Asset Library and check the validation status for the file in the Asset Library.
The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
The output object received from Invoke-D365LcsUpload is piped directly to Get-D365LcsAssetValidationStatus.
The cmdlet will every 60 seconds contact the LCS API endpoint and check if the status of the validation is either success or failure.

All default values will come from the configuration available from Get-D365LcsApiConfig.

## PARAMETERS

### -ProjectId
The project id for the Dynamics 365 for Finance & Operations project inside LCS

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:LcsApiProjectId
Accept pipeline input: False
Accept wildcard characters: False
```

### -BearerToken
The token you want to use when working against the LCS api

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases: Token

Required: False
Position: Named
Default value: $Script:LcsApiBearerToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetId
The unique id of the asset / file that you are trying to deploy from LCS

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LcsApiUri
URI / URL to the LCS API you want to use

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:LcsApiLcsApiUri
Accept pipeline input: False
Accept wildcard characters: False
```

### -WaitForValidation
Instruct the cmdlet to wait for the validation process to complete

The cmdlet will sleep for 60 seconds, before requesting the status of the validation process from LCS

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsDeployment]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

