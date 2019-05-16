---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365RsatPlaybackFile

## SYNOPSIS
Get the RSAT playback files

## SYNTAX

### Default (Default)
```
Get-D365RsatPlaybackFile [-Path <String>] [-Name <String>] [<CommonParameters>]
```

### ExecutionUser
```
Get-D365RsatPlaybackFile [-Name <String>] [-ExecutionUsername <String>] [<CommonParameters>]
```

## DESCRIPTION
Get all the RSAT playback files from the last executions

## EXAMPLES

### EXAMPLE 1
```
Get-D365RsatPlaybackFile
```

This will get all the RSAT playback files.
It will search for the files in the current user AppData system folder.

### EXAMPLE 2
```
Get-D365RsatPlaybackFile -Name *4080*
```

This will get all the RSAT playback files which has "4080" as part of its name.
It will search for the files in the current user AppData system folder.

### EXAMPLE 3
```
Get-D365RsatPlaybackFile -ExecutionUsername RSAT-ServiceAccount
```

This will get all the RSAT playback files that were executed by the RSAT-ServiceAccount user.
It will search for the files in the RSAT-ServiceAccount user AppData system folder.

## PARAMETERS

### -Path
The path where the RSAT tool will be writing the files

The default path is:
"C:\Users\USERNAME\AppData\Roaming\regressionTool\playback"

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: $Script:RsatplaybackPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of Test Case that you are looking for

Default value is "*" which will search for all Test Cases and their corresponding files

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExecutionUsername
Name of the user account has been running the RSAT tests on a machine that isn't the same as the current user

Will enable you to log on to RSAT server that is running the tests from a console, automated, and is other account than the current user

```yaml
Type: String
Parameter Sets: ExecutionUser
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: RSAT, Testing, Regression Suite Automation Test, Regression, Test, Automation, Playback

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
