---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Remove-D365Model

## SYNOPSIS
Remove a model from Dynamics 365 for Finance & Operations

## SYNTAX

```
Remove-D365Model [-Model] <String> [[-BinDir] <String>] [[-MetaDataDir] <String>] [-DeleteFolders]
 [-ShowOriginalProgress] [-OutputCommandOnly] [<CommonParameters>]
```

## DESCRIPTION
Remove a model from a Dynamics 365 for Finance & Operations environment

## EXAMPLES

### EXAMPLE 1
```
Remove-D365Model -Model CustomModelName
```

This will remove the "CustomModelName" model from the D365FO environment.
It will NOT remove the folders inside the PackagesLocalDirectory location.

### EXAMPLE 2
```
Remove-D365Model -Model CustomModelName -DeleteFolders
```

This will remove the "CustomModelName" model from the D365FO environment.
It will remove the folders inside the PackagesLocalDirectory location.
This is helpful when dealing with source control and you want to remove the model entirely.

## PARAMETERS

### -Model
Name of the model that you want to work against

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

### -BinDir
The path to the bin directory for the environment

Default path is the same as the AOS service PackagesLocalDirectory\bin

Default value is fetched from the current configuration on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: "$Script:PackageDirectory\bin"
Accept pipeline input: False
Accept wildcard characters: False
```

### -MetaDataDir
The path to the meta data directory for the environment

Default path is the same as the aos service PackagesLocalDirectory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: "$Script:MetaDataDir"
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteFolders
Instruct the cmdlet to delete the model folder

This is useful when you are trying to clean up the folders in your source control / branch

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

### -ShowOriginalProgress
Instruct the cmdlet to show the standard output in the console

Default is $false which will silence the standard output

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

### -OutputCommandOnly
Instruct the cmdlet to only output the command that you would have to execute by hand

Will include full path to the executable and the needed parameters based on your selection

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
Tags: ModelUtil, Axmodel, Model, Remove, Delete, Source Control, Vsts, Azure DevOps

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
