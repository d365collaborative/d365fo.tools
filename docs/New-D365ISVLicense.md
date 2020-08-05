---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# New-D365ISVLicense

## SYNOPSIS
Create a license deployable package

## SYNTAX

```
New-D365ISVLicense [-LicenseFile] <String> [-Path <String>] [-OutputPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Create a deployable package with a license file inside

## EXAMPLES

### EXAMPLE 1
```
New-D365ISVLicense -LicenseFile "C:\temp\ISVLicenseFile.txt"
```

This will take the "C:\temp\ISVLicenseFile.txt" file and locate the "ImportISVLicense.zip" template file under the "PackagesLocalDirectory\bin\CustomDeployablePackage\".
It will extract the "ImportISVLicense.zip", load the ISVLicenseFile.txt and compress (zip) the files into a deployable package.
The package will be exported to "C:\temp\d365fo.tools\ISVLicense.zip"

## PARAMETERS

### -LicenseFile
Path to the license file that you want to have inside a deployable package

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

### -Path
Path to the template zip file for creating a deployable package with a license file

Default path is the same as the aos service "PackagesLocalDirectory\bin\CustomDeployablePackage\ImportISVLicense.zip"

```yaml
Type: String
Parameter Sets: (All)
Aliases: Template

Required: False
Position: Named
Default value: "$Script:BinDirTools\CustomDeployablePackage\ImportISVLicense.zip"
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Path where you want the generated deployable package stored

Default value is: "C:\temp\d365fo.tools\ISVLicense.zip"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: C:\temp\d365fo.tools\ISVLicense.zip
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@splaxi)
Author: Szabolcs Eötvös

## RELATED LINKS
