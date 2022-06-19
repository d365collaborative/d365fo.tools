---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365PackageBundleDetail

## SYNOPSIS
Get the details from an axscdppkg file

## SYNTAX

```
Get-D365PackageBundleDetail [-Path] <String> [[-ExtractionPath] <String>] [[-KB] <String>] [[-Hotfix] <String>]
 [-Traverse] [-KeepFiles] [-IncludeRawManifest] [<CommonParameters>]
```

## DESCRIPTION
Get the details from an axscdppkg file by extracting it like a zip file.

Capable of extracting the manifest details from the inner packages as well

## EXAMPLES

### EXAMPLE 1
```
Get-D365PackageBundleDetail -Path "c:\temp\HotfixPackageBundle.axscdppkg" -Traverse
```

This will extract all the content from the "HotfixPackageBundle.axscdppkg" file and extract all inner packages.
For each inner package it will find the manifest file and fetch the KB numbers.
The raw manifest file content is included to be analyzed.

### EXAMPLE 2
```
Get-D365PackageBundleDetail -Path "c:\temp\HotfixPackageBundle.axscdppkg" -ExtractionPath C:\Temp\20180905 -Traverse -KeepFiles
```

This will extract all the content from the "HotfixPackageBundle.axscdppkg" file and extract all inner packages.
It will extract the content into C:\Temp\20180905 and keep the files after completion.

### EXAMPLE 3
```
Get-D365PackageBundleDetail -Path C:\temp\HotfixPackageBundle.axscdppkg -Traverse -IncludeRawManifest
```

This is an advanced scenario.

This will traverse the "HotfixPackageBundle.axscdppkg" file and will include the raw manifest file details in the output.

### EXAMPLE 4
```
Get-D365PackageBundleDetail -Path C:\temp\HotfixPackageBundle.axscdppkg -Traverse -IncludeRawManifest | ForEach-Object {$_.RawManifest | Out-File "C:\temp\$($_.PackageId).txt"}
```

This is an advanced scenario.

This will traverse the "HotfixPackageBundle.axscdppkg" file and save the manifest files into c:\temp.
Everything else is omitted and cleaned up.

## PARAMETERS

### -Path
Path to the axscdppkg file you want to analyze

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtractionPath
Path where you want the cmdlet to work with extraction of all the files

Default value is: C:\Users\Username\AppData\Local\Temp

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: ([System.IO.Path]::GetTempPath())
Accept pipeline input: False
Accept wildcard characters: False
```

### -KB
KB number of the hotfix that you are looking for

Accepts wildcards for searching.
E.g.
-KB "4045*"

Default value is "*" which will search for all KB's

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

### -Hotfix
Package Id / Hotfix number the hotfix that you are looking for

Accepts wildcards for searching.
E.g.
-Hotfix "7045*"

Default value is "*" which will search for all hotfixes

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

### -Traverse
Switch to instruct the cmdlet to traverse the inner packages and extract their details

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

### -KeepFiles
Switch to instruct the cmdlet to keep the files for further manual analyze

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

### -IncludeRawManifest
Switch to instruct the cmdlet to include the raw content of the manifest file

Only works with the -Traverse option

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
Tags: Hotfix, KB, Manifest, HotfixPackageBundle, axscdppkg, Package, Bundle, Deployable

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
