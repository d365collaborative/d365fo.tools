---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Repair-D365BacpacModelFile

## SYNOPSIS
Repair a bacpac model file

## SYNTAX

```
Repair-D365BacpacModelFile [-Path] <String> [[-OutputPath] <String>] [[-PathRepairSimple] <String>]
 [[-PathRepairQualifier] <String>] [[-PathRepairReplace] <String>] [-KeepFiles] [-Force] [<CommonParameters>]
```

## DESCRIPTION
As the backend of the Azure SQL infrastructure keeps evolving, the bacpac file can contain invalid instructions while we are trying to import into a local SQL Server installation on a Tier1 environment

## EXAMPLES

### EXAMPLE 1
```
Repair-D365BacpacModelFile -Path C:\Temp\\Base.xml -PathRepairSimple '' -PathRepairQualifier '' -PathRepairReplace 'C:\Temp\RepairBacpac.Replace.Custom.json'
```

This will only process the Replace section, as the other repair paths are empty - indicating to skip them.
It will load the instructions from the 'C:\Temp\RepairBacpac.Replace.Custom.json' file and run those in the Replace section.

### EXAMPLE 2
```
Repair-D365BacpacModelFile -Path C:\Temp\\Base.xml -KeepFiles -Force
```

This will process all repair sections.
It will keep the files in the temporary work directory, for the user to analyze the files further.
It will Force overwrite the output file, if it exists already.

## PARAMETERS

### -Path
Path to the bacpac model file that you want to work against

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

### -OutputPath
Path to where the repaired model file should be placed

The default value is going to create a file next to the Path (input) file, with the '-edited' name appended to it

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PathRepairSimple
Path to the json file, that contains all the instructions to be executed in the "Simple" section

The default json file is part of the module, and can be located with the below command:
explorer.exe $(Join-Path -Path $(Split-Path -Path (Get-Module d365fo.tools -ListAvailable)\[0\].Path -Parent) -ChildPath "internal\misc")
- Look for the "RepairBacpac.Simple.json" file

Or you can see the latest version, online, inside the github repository: https://github.com/d365collaborative/d365fo.tools/tree/master/d365fo.tools/internal/misc/RepairBacpac.Simple.json

Simple means, that we can remove complex elements, based on some basic logic.
E.g.

{
"Search": "*\<Element Type=\"SqlPermissionStatement\"*ms_db_configreader*",
"End": "*\</Element\>*"
}

"*\<Element Type=\"SqlPermissionStatement\"*ms_db_configreader*" can identify below, and together with "*\</Element\>*" - we know when to stop.

\<Element Type="SqlPermissionStatement" Name="\[Grant.Delete.Object\].\[ms_db_configreader\].\[dbo\].\[dbo\].\[AutotuneBase\]"\>
\<Property Name="Permission" Value="4" /\>
\<Relationship Name="Grantee"\>
\<Entry\>
\<References Name="\[ms_db_configreader\]" /\>
\</Entry\>
\</Relationship\>
\<Relationship Name="Grantor"\>
\<Entry\>
\<References ExternalSource="BuiltIns" Name="\[dbo\]" /\>
\</Entry\>
\</Relationship\>
\<Relationship Name="SecuredObject"\>
\<Entry\>
\<References Name="\[dbo\].\[AutotuneBase\]" /\>
\</Entry\>
\</Relationship\>
\</Element\>

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: "$script:ModuleRoot\internal\misc\RepairBacpac.Simple.json"
Accept pipeline input: False
Accept wildcard characters: False
```

### -PathRepairQualifier
Path to the json file, that contains all the instructions to be executed in the "Qualifier" section

The default json file is part of the module, and can be located with the below command:
explorer.exe $(Join-Path -Path $(Split-Path -Path (Get-Module d365fo.tools -ListAvailable)\[0\].Path -Parent) -ChildPath "internal\misc")
- Look for the "RepairBacpac.Qualifier.json" file

Or you can see the latest version, online, inside the github repository: https://github.com/d365collaborative/d365fo.tools/tree/master/d365fo.tools/internal/misc/RepairBacpac.Qualifier.json

Qualifier means, that we can remove complex elements, based on some basic logic.
E.g.

{
"Search": "*\<Element Type=\"SqlRoleMembership\"\>*",
"Qualifier": "*\<References Name=*ms_db_configwriter*",
"End": "*\</Element\>*"
}

"*\<Element Type=\"SqlRoleMembership\"\>*" can identify below, "*\<References Name=*ms_db_configwriter*" qualifies that we are locating the correct one and together with "*\</Element\>*" - we know when to stop.

\<Element Type="SqlRoleMembership"\>
\<Relationship Name="Member"\>
\<Entry\>
\<References Name="\[ms_db_configwriter\]" /\>
\</Entry\>
\</Relationship\>
\<Relationship Name="Role"\>
\<Entry\>
\<References ExternalSource="BuiltIns" Name="\[db_ddladmin\]" /\>
\</Entry\>
\</Relationship\>
\</Element\>

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: "$script:ModuleRoot\internal\misc\RepairBacpac.Qualifier.json"
Accept pipeline input: False
Accept wildcard characters: False
```

### -PathRepairReplace
Path to the json file, that contains all the instructions to be executed in the "Replace" section

The default json file is part of the module, and can be located with the below command:
explorer.exe $(Join-Path -Path $(Split-Path -Path (Get-Module d365fo.tools -ListAvailable)\[0\].Path -Parent) -ChildPath "internal\misc")
- Look for the "RepairBacpac.Replace.json" file

Or you can see the latest version, online, inside the github repository: https://github.com/d365collaborative/d365fo.tools/tree/master/d365fo.tools/internal/misc/RepairBacpac.Replace.json

Replace means, that we can replace/remove strings, based on some basic logic.
E.g.

{
"Search": "\<Property Name=\"AutoDrop\" Value=\"True\" /\>",
"Replace": ""
}

"\<Property Name=\"AutoDrop\" Value=\"True\" /\>" can identify below, and "" is the value we want to replace with it.

\<Property Name="AutoDrop" Value="True" /\>

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: "$script:ModuleRoot\internal\misc\RepairBacpac.Replace.json"
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeepFiles
Instruct the cmdlet to keep the files from the repair process

The files are very large, so only use this as a way to analyze why your model file didn't end up in the desired state

Use it while you evolve/develop your instructions, but remove it from ANY full automation scripts

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

### -Force
Instruct the cmdlet to overwrite the file specified in the OutputPath if it already exists

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
Author: Mötz Jensen (@Splaxi)
Author: Florian Hopfner (@FH-Inway)

Json files has to be an array directly in the root of the file.
All " (double quotes) has to be escaped with \" - otherwise it will not work as intended.

This cmdlet is inspired by the work of "Brad Bateman" (github: @batetech)

His github profile can be found here:
https://github.com/batetech

Florian Hopfner did a gist implementation, which has been used as the foundation for this implementation

The original gist is: https://gist.github.com/FH-Inway/f485c720b43b72bffaca5fb6c094707e

His github profile can be found here:
https://github.com/FH-Inway

## RELATED LINKS
