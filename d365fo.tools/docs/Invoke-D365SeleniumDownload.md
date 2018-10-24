---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365SeleniumDownload

## SYNOPSIS
Downloads the Selenium web driver files and deploys them to the specified destinations.

## SYNTAX

```
Invoke-D365SeleniumDownload [-RegressionSuiteAutomationTool] [-PerfSDK] [<CommonParameters>]
```

## DESCRIPTION
Downloads the Selenium web driver files and deploys them to the specified destinations.

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SeleniumDownload -RegressionSuiteAutomationTool -PerfSDK
```

This will download the Selenium zip archives and extract the files into both the Regression Suite Automation Tool folder and the PerfSDK folder.

## PARAMETERS

### -RegressionSuiteAutomationTool
Switch to specify if the Selenium files need to be installed in the Regression Suite Automation Tool folder.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PerfSDK
Switch to specify if the Selenium files need to be installed in the PerfSDK folder.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Author: Kenny Saelen (@kennysaelen)

## RELATED LINKS
