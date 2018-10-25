---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Set-D365SDPCleanUp

## SYNOPSIS
Set the cleanup retention period

## SYNTAX

```
Set-D365SDPCleanUp [[-NumberOfDays] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Sets the configured retention period before updates are deleted

## EXAMPLES

### EXAMPLE 1
```
Set-D365SDPCleanUp -NumberOfDays 10
```

This will set the retention period to 10 days inside the the registry

The cmdlet REQUIRES elevated permissions to run, otherwise it will fail

## PARAMETERS

### -NumberOfDays
Number of days that deployable software packages should remain on the server

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This cmdlet is based on the findings from Alex Kwitny (@AlexOnDAX)

See his blog for more info:
http://www.alexondax.com/2018/04/msdyn365fo-how-to-adjust-your.html

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
