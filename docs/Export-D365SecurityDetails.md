---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Export-D365SecurityDetails

## SYNOPSIS
Extract details from a User Interface Security file

## SYNTAX

```
Export-D365SecurityDetails [-FilePath] <String> [[-OutputDirectory] <String>] [<CommonParameters>]
```

## DESCRIPTION
Extracts and partitions the security details from an User Interface Security file into the same structure as AOT security files

## EXAMPLES

### EXAMPLE 1
```
Export-D365SecurityDetails -FilePath C:\temp\d365fo.tools\SecurityDatabaseCustomizations.xml
```

This will grab all the details inside the "C:\temp\d365fo.tools\SecurityDatabaseCustomizations.xml" file and extract that into the default path "C:\temp\d365fo.tools\security-extraction"

## PARAMETERS

### -FilePath
Path to the User Interface Security XML file you want to work against

```yaml
Type: String
Parameter Sets: (All)
Aliases: Path

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputDirectory
Path to the folder where the cmdlet will output and structure the details from the file.
The cmdlet will create a sub folder named like the input file.

Default value is: "C:\temp\d365fo.tools\security-extraction"

```yaml
Type: String
Parameter Sets: (All)
Aliases: Output

Required: False
Position: 2
Default value: C:\temp\d365fo.tools\security-extraction
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

The work and design of this cmdlet is based on the findings by Alex Meyer (@alexmeyer_ITGuy).

He wrote about his findings on his blog:
https://alexdmeyer.com/2018/09/26/converting-d365fo-user-interface-security-customizations-export-to-aot-security-xml-files/

He published a github repository:

https://github.com/ameyer505/D365FOSecurityConverter

All credits goes to Alex Meyer

## RELATED LINKS
