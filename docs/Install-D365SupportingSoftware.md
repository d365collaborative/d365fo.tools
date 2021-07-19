---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Install-D365SupportingSoftware

## SYNOPSIS
Install software supporting F&O development

## SYNTAX

```
Install-D365SupportingSoftware [-Name] <String[]> [-Force] [<CommonParameters>]
```

## DESCRIPTION
Installs software commonly used when doing Dynamics 365 Finance and Operations development

Common ones: fiddler, postman, microsoft-edge, winmerge, notepadplusplus.install, azurepowershell, azure-cli, insomnia-rest-api-client, git.install

Full list of software: https://community.chocolatey.org/packages

## EXAMPLES

### EXAMPLE 1
```
Install-D365SupportingSoftware -Name vscode
```

This will install VSCode on the system.

### EXAMPLE 2
```
Install-D365SupportingSoftware -Name "vscode","fiddler"
```

This will install VSCode and fiddler on the system.

### EXAMPLE 3
```
Install-D365SupportingSoftware -Name vscode -Force
```

This will install VSCode on the system, forcing it to be (re)installed.

## PARAMETERS

### -Name
The name of the software to install

Support a list of softwares that you want to have installed on the system

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: SoftwareName

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Instruct the cmdlet to install the latest version of the software, regardless if it is already present on the system

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
Author: Dag Calafell (@dodiggitydag)
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
