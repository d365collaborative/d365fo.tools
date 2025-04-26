---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365SDPInstall

## SYNOPSIS
Install a Software Deployable Package (SDP)

## SYNTAX

### QuickInstall (Default)
```
Invoke-D365SDPInstall [-Path] <String> [[-MetaDataDir] <String>] [-QuickInstallAll] [[-Step] <Int32>]
 [[-RunbookId] <String>] [-LogPath <String>] [-ShowOriginalProgress] [-OutputCommandOnly]
 [-TopologyFile <String>] [-UseExistingTopologyFile] [-IncludeFallbackRetailServiceModels] [-Force]
 [-ForceFallbackServiceModels] [<CommonParameters>]
```

### DevInstall
```
Invoke-D365SDPInstall [-Path] <String> [[-MetaDataDir] <String>] [-DevInstall] [[-Step] <Int32>]
 [[-RunbookId] <String>] [-LogPath <String>] [-ShowOriginalProgress] [-OutputCommandOnly]
 [-TopologyFile <String>] [-UseExistingTopologyFile] [-IncludeFallbackRetailServiceModels] [-Force]
 [-ForceFallbackServiceModels] [<CommonParameters>]
```

### Manual
```
Invoke-D365SDPInstall [-Path] <String> [[-MetaDataDir] <String>] [-Command] <String> [[-Step] <Int32>]
 [[-RunbookId] <String>] [-LogPath <String>] [-ShowOriginalProgress] [-OutputCommandOnly]
 [-TopologyFile <String>] [-UseExistingTopologyFile] [-IncludeFallbackRetailServiceModels] [-Force]
 [-ForceFallbackServiceModels] [<CommonParameters>]
```

### UDEInstall
```
Invoke-D365SDPInstall [-Path] <String> [[-MetaDataDir] <String>] [[-Step] <Int32>] [[-RunbookId] <String>]
 [-LogPath <String>] [-ShowOriginalProgress] [-OutputCommandOnly] [-TopologyFile <String>]
 [-UseExistingTopologyFile] [-UnifiedDevelopmentEnvironment] [-IncludeFallbackRetailServiceModels] [-Force]
 [-ForceFallbackServiceModels] [<CommonParameters>]
```

## DESCRIPTION
A cmdlet that wraps some of the cumbersome work into a streamlined process.
The process for a legacy (i.e.
non unified) environment are detailed in the Microsoft documentation here:
https://docs.microsoft.com/en-us/dynamics365/unified-operations/dev-itpro/deployment/install-deployable-package

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SDPInstall -Path "c:\temp\package.zip" -QuickInstallAll
```

This will install the package contained in the c:\temp\package.zip file using a runbook in memory while executing.

### EXAMPLE 2
```
Invoke-D365SDPInstall -Path "c:\temp\" -DevInstall
```

This will install the extracted package in c:\temp\ using a runbook in memory while executing.

This command is to be used on Microsoft Hosted Tier1 development environment, where you don't have access to the administrator user account on the vm.

### EXAMPLE 3
```
Invoke-D365SDPInstall -Path "c:\temp\" -Command SetTopology
```

PS C:\\\> Invoke-D365SDPInstall -Path "c:\temp\" -Command Generate -RunbookId 'MyRunbook'
PS C:\\\> Invoke-D365SDPInstall -Path "c:\temp\" -Command Import -RunbookId 'MyRunbook'
PS C:\\\> Invoke-D365SDPInstall -Path "c:\temp\" -Command Execute -RunbookId 'MyRunbook'

Manual operations that first create Topology XML from current environment, then generate runbook with id 'MyRunbook', then import it and finally execute it.

### EXAMPLE 4
```
Invoke-D365SDPInstall -Path "c:\temp\" -Command RunAll
```

Create Topology XML from current environment.
Using default runbook id 'Runbook' and run all the operations from generate, to import to execute.

### EXAMPLE 5
```
Invoke-D365SDPInstall -Path "c:\temp\" -Command RerunStep -Step 18 -RunbookId 'MyRunbook'
```

Rerun runbook with id 'MyRunbook' from step 18.

### EXAMPLE 6
```
Invoke-D365SDPInstall -Path "c:\temp\" -Command SetStepComplete -Step 24 -RunbookId 'MyRunbook'
```

Mark step 24 complete in runbook with id 'MyRunbook' and continue the runbook from the next step.

### EXAMPLE 7
```
Invoke-D365SDPInstall -Path "c:\temp\" -Command SetTopology -TopologyFile "c:\temp\MyTopology.xml"
```

Update the MyTopology.xml file with all the installed services on the machine.

### EXAMPLE 8
```
Invoke-D365SDPInstall -Path "c:\temp\" -Command RunAll -TopologyFile "c:\temp\MyTopology.xml" -UseExistingTopologyFile
```

Run all manual steps in one single operation using the MyTopology.xml file.
The topology file is not updated.

### EXAMPLE 9
```
Invoke-D365SDPInstall -Path "c:\temp\" -MetaDataDir "c:\MyRepository\Metadata" -UnifiedDevelopmentEnvironment
```

Install the modules contained in the c:\temp\ directory into the c:\MyRepository\Metadata directory.

### EXAMPLE 10
```
Invoke-D365SDPInstall -Path "c:\temp\" -Command RunAll -IncludeFallbackRetailServiceModels
```

Create Topology XML from current environment.
If the current environment does not have the information about the installed service models, a fallback list of known service model names will be used.
This fallback list includes the retail service models.
Using default runbook id 'Runbook' and run all the operations from generate, to import to execute.

### EXAMPLE 11
```
Invoke-D365SDPInstall -Path "c:\temp\" -Command RunAll -ForceFallbackServiceModels
```

Create Topology XML from current environment.
If the current environment does have no or only partial information about the installed service models, a fallback list of known service model names will be used.
This fallback list does not include the retail service models.
Using default runbook id 'Runbook' and run all the operations from generate, to import to execute.

## PARAMETERS

### -Path
Path to the update package that you want to install into the environment

The cmdlet supports a path to a zip-file or directory with the unpacked contents.

```yaml
Type: String
Parameter Sets: (All)
Aliases: File, Hotfix

Required: True
Position: 2
Default value: None
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
Position: 3
Default value: "$Script:MetaDataDir"
Accept pipeline input: False
Accept wildcard characters: False
```

### -QuickInstallAll
Use this switch to let the runbook reside in memory.
You will not get a runbook on disc which you can examine for steps

```yaml
Type: SwitchParameter
Parameter Sets: QuickInstall
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DevInstall
Use this when running on developer box without administrator privileges (Run As Administrator)

```yaml
Type: SwitchParameter
Parameter Sets: DevInstall
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Command
The command you want the cmdlet to execute when it runs the AXUpdateInstaller.exe

Valid options are:
SetTopology
Generate
Import
Execute
RunAll
ReRunStep
SetStepComplete
Export
VersionCheck

The default value is "SetTopology"

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: True
Position: 4
Default value: SetTopology
Accept pipeline input: False
Accept wildcard characters: False
```

### -Step
The step number that you want to work against

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunbookId
The runbook id of the runbook that you want to work against

Default value is "Runbook"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Runbook
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogPath
The path where the log file(s) will be saved

When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed

```yaml
Type: String
Parameter Sets: (All)
Aliases: LogDir

Required: False
Position: Named
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\SdpInstall")
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

### -TopologyFile
Provide a custom topology file to use.
By default, the cmdlet will use the DefaultTopologyData.xml file in the package directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: DefaultTopologyData.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseExistingTopologyFile
Use this switch to indicate that the topology file is already updated and should not be updated again.

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

### -UnifiedDevelopmentEnvironment
Use this switch to install the package in a Unified Development Environment (UDE).

```yaml
Type: SwitchParameter
Parameter Sets: UDEInstall
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeFallbackRetailServiceModels
Include fallback retail service models in the topology file

This parameter is to support backward compatibility in this scenario:
Installing the first update on a local VHD where the information about the installed service
models may not be available and where the retail components are installed.
More information about this can be found at https://github.com/d365collaborative/d365fo.tools/issues/878

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
Instruct the cmdlet to overwrite the "extracted" folder if it exists

Used when the input is a zip file, that will auto extract to a folder named like the zip file.

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

### -ForceFallbackServiceModels
Force the use of the fallback list of known service model names

This parameter supports update scenarios primarily on local VHDs where the information about
the installed service models may be incomplete.
In such a case, the user receives a warning
and a suggestion to use this parameter.

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
Author: Tommy Skaue (@skaue)
Author: Mötz Jensen (@Splaxi)
Author: Florian Hopfner (@FH-Inway)

Inspired by blogpost http://dev.goshoom.net/en/2016/11/installing-deployable-packages-with-powershell/

## RELATED LINKS

[Invoke-D365SDPInstallUDE]()

