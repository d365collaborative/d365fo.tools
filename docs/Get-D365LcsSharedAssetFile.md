﻿---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsSharedAssetFile

## SYNOPSIS
Get information for assets from the shared asset library of LCS

## SYNTAX

```
Get-D365LcsSharedAssetFile [[-ProjectId] <Int32>] [[-FileType] <LcsAssetFileType>] [[-AssetName] <String>]
 [[-AssetVersion] <String>] [[-AssetFilename] <String>] [[-AssetDescription] <String>] [[-AssetId] <String>]
 [[-BearerToken] <String>] [[-LcsApiUri] <String>] [-Latest] [-SkipSasGeneration] [[-RetryTimeout] <TimeSpan>]
 [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Get the information for the file assets from the shared asset library of LCS matching the search criteria

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsSharedAssetFile -ProjectId 123456789 -FileType SoftwareDeployablePackage -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will list all Software Deployable Packages in the shared asset library.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

### EXAMPLE 2
```
Get-D365LcsSharedAssetFile -FileType SoftwareDeployablePackage
```

This will list all Software Deployable Packages in the shared asset library.
It will search for SoftwareDeployablePackage by using the FileType parameter.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 3
```
Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -AssetFilename "*MAIN*"
```

This will list all Software Deployable Packages in the shared asset library that match the "*MAIN*" search pattern in the file name of the asset.
It will search for SoftwareDeployablePackage by using the FileType parameter.
It will filter the output to match the AssetFilename "*MAIN*" search pattern.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 4
```
Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -AssetName "*MAIN*"
```

This will list all Software Deployable Packages in the shared asset library that match the "*MAIN*" search pattern in the name of the asset.
It will search for SoftwareDeployablePackage by using the FileType parameter.
It will filter the output to match the AssetName "*MAIN*" search pattern.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 5
```
Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -AssetDescription "*TEST*"
```

This will list all Software Deployable Packages in the shared asset library that match the "*TEST*" search pattern in the asset description.
It will search for SoftwareDeployablePackage by using the FileType parameter.
It will filter the output to match the AssetDescription "*TEST*" search pattern.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 6
```
Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -AssetId "500dd860-eacf-4e04-9f18-f9c8fe1d8e03"
```

This will list all Software Deployable Packages in the shared asset library that match the "500dd860-eacf-4e04-9f18-f9c8fe1d8e03" search pattern in the asset id.
It will search for SoftwareDeployablePackage by using the FileType parameter.
It will filter the output to match the AssetId "500dd860-eacf-4e04-9f18-f9c8fe1d8e03" search pattern.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 7
```
$asset = Get-D365LcsSharedAssetFile -FileType SoftwareDeployablePackage -Latest
```

PS C:\\\> Invoke-D365AzCopyTransfer -SourceUri $asset.FileLocation -DestinationUri C:\Temp\d365fo.tools\$($asset.Filename) -ShowOriginalProgress

This will download the latest Software Deployable Package from the shared asset library in LCS onto your local machine.
It will list Software Deployable Packages based on the FileType parameter.
It will list the latest (newest) Software Deployable Package.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 8
```
Get-D365LcsSharedAssetFile -FileType SoftwareDeployablePackage -RetryTimeout "00:01:00"
```

This will list all Software Deployable Packages in the shared asset library and allow for the cmdlet to retry for no more than 1 minute.
It will search for SoftwareDeployablePackage by using the FileType parameter.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 9
```
Get-D365LcsSharedAssetFile -FileType SoftwareDeployablePackage -SkipSasGeneration
```

This will list all Software Deployable Packages in the shared asset library, but skip the SAS / Download generation
It will search for SoftwareDeployablePackage by using the FileType parameter.

This will increase the speed getting the list of assets - but you will not get a downloadable link.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

## PARAMETERS

### -ProjectId
The project id for the Dynamics 365 for Finance & Operations project inside LCS

Default value can be configured using Set-D365LcsApiConfig

Although the assets are stored in the shared asset library, their information is retrieved in context of a project to get the full information.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:LcsApiProjectId
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileType
Type of file you want to list from the LCS Asset Library

Valid options:
"Model"
"Process Data Package"
"Software Deployable Package"
"GER Configuration"
"Data Package"
"PowerBI Report Model"
"E-Commerce Package"
"NuGet Package"
"Retail Self-Service Package"
"Commerce Cloud Scale Unit Extension"

Default value is "Software Deployable Package"

```yaml
Type: LcsAssetFileType
Parameter Sets: (All)
Aliases:
Accepted values: Model, ProcessDataPackage, SoftwareDeployablePackage, GERConfiguration, DataPackage, PowerBIReportModel, ECommercePackage, NuGetPackage, RetailSelfServicePackage, CommerceCloudScaleUnitExtension

Required: False
Position: 2
Default value: SoftwareDeployablePackage
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetName
Name of the asset that you are looking for

Accepts wildcards for searching.
E.g.
-AssetName "*ISV*"

Default value is "*" which will search for all assets via the Name property

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetVersion
Version of the Asset file that you are looking for

It does a simple compare against the response from LCS and only lists the ones that matches

Accepts wildcards for searching.
E.g.
-AssetVersion "*ISV*"

Default value is "*" which will search for all files

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetFilename
Name of the file that you are looking for

Accepts wildcards for searching.
E.g.
-AssetFilename "*ISV*"

Default value is "*" which will search for all files via the FileName property

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetDescription
Name of the file that you are looking for

Accepts wildcards for searching.
E.g.
-AssetDescription "*ISV*"

Default value is "*" which will search for all files via the FileDescription property

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetId
Id of the file that you are looking for

Accepts wildcards for searching.
E.g.
-AssetId "*ISV*"

Default value is "*" which will search for all files via the AssetId property

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: *
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
Position: 8
Default value: $Script:LcsApiBearerToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -LcsApiUri
URI / URL to the LCS API you want to use

The value depends on where your LCS project is located.
There are multiple valid URI's / URL's

Valid options:
"https://lcsapi.lcs.dynamics.com"
"https://lcsapi.eu.lcs.dynamics.com"
"https://lcsapi.fr.lcs.dynamics.com"
"https://lcsapi.sa.lcs.dynamics.com"
"https://lcsapi.uae.lcs.dynamics.com"
"https://lcsapi.ch.lcs.dynamics.com"
"https://lcsapi.no.lcs.dynamics.com"
"https://lcsapi.lcs.dynamics.cn"
"https://lcsapi.gov.lcs.microsoftdynamics.us"

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: $Script:LcsApiLcsApiUri
Accept pipeline input: False
Accept wildcard characters: False
```

### -Latest
Instruct the cmdlet to only fetch the latest file from the Asset Library from LCS

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: GetLatest

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipSasGeneration
Instruct the cmdlet to only fetch the meta data from the asset file (entry)

This is to speed up the listing of entries, in some of the larger areas in the Shared Asset Library

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

### -RetryTimeout
The retry timeout, before the cmdlet should quit retrying based on the 429 status code

Needs to be provided in the timspan notation:
"hh:mm:ss"

hh is the number of hours, numerical notation only
mm is the number of minutes
ss is the numbers of seconds

Each section of the timeout has to valid, e.g.
hh can maximum be 23
mm can maximum be 59
ss can maximum be 59

Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 00:00:00
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts
Usually this parameter is not used directly, but via the Enable-D365Exception cmdlet
See https://github.com/d365collaborative/d365fo.tools/wiki/Exception-handling#what-does-the--enableexception-parameter-do for further information

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
Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Invoke-D365LcsApiRefreshToken]()

[Set-D365LcsApiConfig]()

[Get-D365LcsAssetFile]()

