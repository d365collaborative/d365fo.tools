---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365DecryptedConfigFile

## SYNOPSIS
Decrypts the AOS config file

## SYNTAX

```
Get-D365DecryptedConfigFile [[-DropPath] <String>] [[-AosServiceWebRootPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Function used for decrypting the config file used by the D365 Finance & Operations AOS service

## EXAMPLES

### EXAMPLE 1
```
Get-D365DecryptedConfigFile -DropPath "c:\temp\d365fo.tools"
```

This will get the config file from the instance, decrypt it and save it to "c:\temp\d365fo.tools"

## PARAMETERS

### -DropPath
Place where the decrypted files should be placed

```yaml
Type: String
Parameter Sets: (All)
Aliases: ExtractFolder

Required: False
Position: 2
Default value: C:\temp\d365fo.tools\ConfigFile_Decrypted
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
Position: 3
Default value: $Script:AOSPath
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Used for getting the Password for the database and other service accounts used in environment

Author : Rasmus Andersen (@ITRasmus)
Author : Mötz Jensen (@splaxi)

## RELATED LINKS
