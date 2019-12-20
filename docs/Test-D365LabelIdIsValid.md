---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Test-D365LabelIdIsValid

## SYNOPSIS
Checks if a string is a valid 'Label Id' format

## SYNTAX

```
Test-D365LabelIdIsValid [-LabelId] <String> [<CommonParameters>]
```

## DESCRIPTION
This function will validate if a string is a valid 'Label Id' format.

## EXAMPLES

### EXAMPLE 1
```
Test-D365LabelIdIsValid -LabelId "ABC123"
```

This will test the if the LabelId is valid.
It will use the "ABC123" as the LabelId parameter.

The expected result is $true

### EXAMPLE 2
```
Test-D365LabelIdIsValid -LabelId "@ABC123"
```

This will test the if the LabelId is valid.
It will use the "@ABC123" as the LabelId parameter.

The expected result is $true

### EXAMPLE 3
```
Test-D365LabelIdIsValid -LabelId "@ABC123_1"
```

This will test the if the LabelId is valid.
It will use the "@ABC123_1" as the LabelId parameter.

The expected result is $false

### EXAMPLE 4
```
Test-D365LabelIdIsValid -LabelId "ABC.123" #False
```

This will test the if the LabelId is valid.
It will use the "ABC.123" as the LabelId parameter.

The expected result is $false

## PARAMETERS

### -LabelId
The LabelId string thay you want to validate

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean
## NOTES
Author: Alex Kwitny (@AlexOnDAX)

The intent of this function is to be used with other methods to create valid labels via scripting.

## RELATED LINKS
