---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsEnvironmentRsatCertificate

## SYNOPSIS
Get LCS environment rsat certificate from within a project

## SYNTAX

```
Get-D365LcsEnvironmentRsatCertificate [[-ProjectId] <Int32>] [[-BearerToken] <String>]
 [-EnvironmentId] <String> [[-OutputPath] <String>] [[-LcsApiUri] <String>] [-FailOnErrorMessage]
 [[-RetryTimeout] <TimeSpan>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Download and persist the active rsat certificate from environments from within a LCS project

## EXAMPLES

### EXAMPLE 1
```
Get-D365LcsEnvironmentRsatCertificate -ProjectId "123456789" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
```

This will download the active rsat certificate file for the environment from the LCS project.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.

A result set example:

Path     : c:\temp\d365fo.tools\RsatCert\RSATCertificate_ABC-UAT_20240101-012030
CerFile  : C:\temp\d365fo.tools\RsatCert\RSATCertificate_ABC-UAT_20240101-012030\RSATCertificate_ABC-UAT_20240101-012030.cer
PfxFile  : C:\temp\d365fo.tools\RsatCert\RSATCertificate_ABC-UAT_20240101-012030\RSATCertificate_ABC-UAT_20240101-012030.pfx
FileName : RSATCertificate_ABC-UAT_20240101-012030.zip
Password : 9zbPiLMTk676mkq5FvqQ

### EXAMPLE 2
```
Get-D365LcsEnvironmentRsatCertificate -ProjectId "123456789" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" | Import-D365RsatSelfServiceCertificates
```

This will download the active rsat certificate file for the environment from the LCS project.
The resulting files are then imported into the certificate store on the local machine.

## PARAMETERS

### -ProjectId
The project id for the Dynamics 365 for Finance & Operations project inside LCS

Default value can be configured using Set-D365LcsApiConfig

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

### -BearerToken
The token you want to use when working against the LCS api

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases: Token

Required: False
Position: 2
Default value: $Script:LcsApiBearerToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnvironmentId
Id of the environment that you want to be working against

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

### -OutputPath
Path to where you want the certificate files to be saved

The default value is: "c:\temp\d365fo.tools\RsatCert\"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $(Join-Path $Script:DefaultTempPath "RsatCert")
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
Position: 5
Default value: $Script:LcsApiLcsApiUri
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailOnErrorMessage
Instruct the cmdlet to write logging information to the console, if there is an error message in the response from the LCS endpoint

Used in combination with either Enable-D365Exception cmdlet, or the -EnableException directly on this cmdlet, it will throw an exception and break/stop execution of the script
This allows you to implement custom retry / error handling logic

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
Position: 6
Default value: 00:00:00
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts

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

### PSCustomObject
## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
