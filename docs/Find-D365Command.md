---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Find-D365Command

## SYNOPSIS
Finds d365fo.tools commands searching through the inline help text

## SYNTAX

```
Find-D365Command [[-Pattern] <String>] [[-Tag] <String[]>] [[-Author] <String>] [[-MinimumVersion] <String>]
 [[-MaximumVersion] <String>] [-Rebuild] [-EnableException] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Finds d365fo.tools commands searching through the inline help text, building a consolidated json index and querying it because Get-Help is too slow

## EXAMPLES

### EXAMPLE 1
```
Find-D365Command "snapshot"
```

For lazy typers: finds all commands searching the entire help for "snapshot"

### EXAMPLE 2
```
Find-D365Command -Pattern "snapshot"
```

For rigorous typers: finds all commands searching the entire help for "snapshot"

### EXAMPLE 3
```
Find-D365Command -Tag copy
```

Finds all commands tagged with "copy"

### EXAMPLE 4
```
Find-D365Command -Tag copy,user
```

Finds all commands tagged with BOTH "copy" and "user"

### EXAMPLE 5
```
Find-D365Command -Author Mötz
```

Finds every command whose author contains "Mötz"

### EXAMPLE 6
```
Find-D365Command -Author Mötz -Tag copy
```

Finds every command whose author contains "Mötz" and it tagged as "copy"

### EXAMPLE 7
```
Find-D365Command -Pattern snapshot -Rebuild
```

Finds all commands searching the entire help for "snapshot", rebuilding the index (good for developers)

## PARAMETERS

### -Pattern
Searches help for all commands in d365fo.tools for the specified pattern and displays all results

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
Finds all commands tagged with this auto-populated tag

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Author
Finds all commands tagged with this author

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinimumVersion
Finds all commands tagged with this auto-populated minimum version

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaximumVersion
Finds all commands tagged with this auto-populated maximum version

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rebuild
Rebuilds the index

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

### -EnableException
By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
This avoids overwhelming you with "sea of red" exceptions, but is inconvenient because it basically disables advanced scripting.
Using this switch turns this "nice by default" feature off and enables you to catch exceptions with your own try/catch.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Silent

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Displays what would happen if the command is run

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Confirms overwrite of index

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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
Tags: Find, Help, Command
Author: Mötz Jensen (@Splaxi)

License: MIT https://opensource.org/licenses/MIT

This cmdlet / function is copy & paste implementation based on the Find-DbaCommand from the dbatools.io project

Original author: Simone Bizzotto (@niphold)

## RELATED LINKS
