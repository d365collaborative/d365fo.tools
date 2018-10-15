---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365SCDPBundleInstall

## SYNOPSIS
Invoke the SCDPBundleInstall.exe file

## SYNTAX

### InstallOnly (Default)
```
Invoke-D365SCDPBundleInstall [-InstallOnly] [-Path] <String> [[-MetaDataDir] <String>] [-ShowModifiedFiles]
 [<CommonParameters>]
```

### Tfs
```
Invoke-D365SCDPBundleInstall [-Command] <String> [-Path] <String> [[-MetaDataDir] <String>]
 [[-TfsWorkspaceDir] <String>] [[-TfsUri] <String>] [-ShowModifiedFiles] [<CommonParameters>]
```

## DESCRIPTION
A cmdlet that wraps some of the cumbersome work into a streamlined process

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SCDPBundleInstall -Path "c:\temp\HotfixPackageBundle.axscdppkg"
```

This will install the "HotfixPackageBundle.axscdppkg" into the default 
PackagesLocalDirectory location on the machine

## PARAMETERS

### -InstallOnly
Switch to instruct the cmdlet to only run the Install option and ignore any TFS / VSTS folders
and source control in general

Use it when testing an update on a local development machine (VM) / onebox

```yaml
Type: SwitchParameter
Parameter Sets: InstallOnly
Aliases:

Required: True
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Command
{{Fill Command Description}}

```yaml
Type: String
Parameter Sets: Tfs
Aliases:

Required: True
Position: 1
Default value: Prepare
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to the update package that you want to install into the environment

The cmdlet only supports an already extracted ".axscdppkg" file

```yaml
Type: String
Parameter Sets: (All)
Aliases: File, Hotfix

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MetaDataDir
The path to the meta data directory for the environment 

Default path is the same as the aos service packageslocaldirectory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: "$Script:MetaDataDir"
Accept pipeline input: False
Accept wildcard characters: False
```

### -TfsWorkspaceDir
{{Fill TfsWorkspaceDir Description}}

```yaml
Type: String
Parameter Sets: Tfs
Aliases:

Required: False
Position: 4
Default value: "$Script:MetaDataDir"
Accept pipeline input: False
Accept wildcard characters: False
```

### -TfsUri
{{Fill TfsUri Description}}

```yaml
Type: String
Parameter Sets: Tfs
Aliases:

Required: False
Position: 5
Default value: "$Script:TfsUri"
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowModifiedFiles
{{Fill ShowModifiedFiles Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Author: Mötz Jensen (@splaxi)

## RELATED LINKS
