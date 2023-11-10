---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365RsatConfiguration

## SYNOPSIS
Set different RSAT configuration values

## SYNTAX

```
Set-D365RsatConfiguration [[-LogGenerationEnabled] <Boolean>] [[-VerboseSnapshotsEnabled] <Boolean>]
 [[-AddOperatorFieldsToExcelValidationEnabled] <Boolean>] [[-RSATConfigFilename] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Update different RSAT configuration values while using the tool

## EXAMPLES

### EXAMPLE 1
```
Set-D365RsatConfiguration -LogGenerationEnabled $true
```

This will enable the log generation logic of RSAT.

### EXAMPLE 2
```
Set-D365RsatConfiguration -VerboseSnapshotsEnabled $true
```

This will enable the snapshot generation logic of RSAT.

### EXAMPLE 3
```
Set-D365RsatConfiguration -AddOperatorFieldsToExcelValidationEnabled $true
```

This will enable the operator generation logic of RSAT.

## PARAMETERS

### -LogGenerationEnabled
Will set the LogGeneration property

$true will make RSAT start generating logs
$false will stop RSAT from generating logs

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerboseSnapshotsEnabled
Will set the VerboseSnapshotsEnabled property

$true will make RSAT start generating snapshots and store related details
$false will stop RSAT from generating snapshots and store related details

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AddOperatorFieldsToExcelValidationEnabled
Will set the AddOperatorFieldsToExcelValidation property

$true will make RSAT start adding the operation options in the excel parameter file
$false will stop RSAT from adding the operation options in the excel parameter file

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RSATConfigFilename
Specifies the file name of the RSAT configuration file.
Default is 'Microsoft.Dynamics.RegressionSuite.WpfApp.exe.config'
If you are using an older version of RSAT, you might need to change this to 'Microsoft.Dynamics.RegressionSuite.WindowsApp.exe.config'

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Microsoft.Dynamics.RegressionSuite.WpfApp.exe.config
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: RSAT, Testing, Regression Suite Automation Test, Regression, Test, Automation, Configuration

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
