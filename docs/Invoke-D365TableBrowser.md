---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365TableBrowser

## SYNOPSIS
Start a browser session that will show the table browser

## SYNTAX

```
Invoke-D365TableBrowser [-TableName] <String> [[-Company] <String>] [[-Url] <String>] [<CommonParameters>]
```

## DESCRIPTION
Makes it possible to call the table browser for a given table directly from the web browser, without worrying about the details

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365TableBrowser -TableName SalesTable
```

Will open the table browser and show all the records in Sales Table from the "DAT" company (default value).

### EXAMPLE 2
```
Invoke-D365TableBrowser -TableName SalesTable -Company "USMF"
```

Will open the table browser and show all the records in Sales Table from the "USMF" company.

## PARAMETERS

### -TableName
The name of the table you want to see the rows for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Company
The company for which you want to see the data from in the given table

Default value is: "DAT"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:Company
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Url
The URL you want to execute against

Default value is the Fully Qualified Domain Name registered on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:Url
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
