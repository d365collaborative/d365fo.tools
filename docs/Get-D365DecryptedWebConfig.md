---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365DecryptedWebConfig

## SYNOPSIS
Decrypts the AOS config file

## SYNTAX

```
Get-D365DecryptedWebConfig [[-OutputPath] <String>] [[-AosServiceWebRootPath] <String>]
```

## DESCRIPTION
Function used for decrypting the config file used by the D365 Finance & Operations AOS service

## EXAMPLES

### EXAMPLE 1
```
Get-D365DecryptedWebConfig
```

This will get the config file from the instance, decrypt it and save it.
IT will save the decrypted web.config file in the default location: "c:\temp\d365fo.tools\WebConfigDecrypted".

A result set example:

Filename   LastModified        File
--------   ------------        ----
web.config 7/1/2021 9:01:31 PM C:\temp\d365fo.tools\WebConfigDecrypted\web.config

### EXAMPLE 2
```
Get-D365DecryptedWebConfig -OutputPath "c:\temp\d365fo.tools"
```

This will get the config file from the instance, decrypt it and save it to "c:\temp\d365fo.tools"

A result set example:

Filename   LastModified        File
--------   ------------        ----
web.config 7/1/2021 9:07:36 PM C:\temp\d365fo.tools\web.config

## PARAMETERS

### -OutputPath
Place where the decrypted files should be placed

Default value is: "c:\temp\d365fo.tools\WebConfigDecrypted"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: C:\temp\d365fo.tools\WebConfigDecrypted
Accept pipeline input: False
Accept wildcard characters: False
```

### -AosServiceWebRootPath
Location of the D365 webroot folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:AOSPath
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Tags: Configuration, Service Account, Sql, SqlUser, SqlPwd, WebConfig, Web.Config, Decryption

Author : Rasmus Andersen (@ITRasmus)
Author : Mötz Jensen (@splaxi)

Used for getting the Password for the database and other service accounts used in environment

## RELATED LINKS
