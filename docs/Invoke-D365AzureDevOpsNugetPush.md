---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365AzureDevOpsNugetPush

## SYNOPSIS
Push a package / nuget to Azure DevOps

## SYNTAX

```
Invoke-D365AzureDevOpsNugetPush [[-Path] <String>] [[-Source] <String>] [[-LogPath] <String>]
 [-ShowOriginalProgress] [-OutputCommandOnly] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION
Push a package / nuget to an Azure DevOps feed

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365AzureDevOpsNugetPush -Path "c:\temp\d365fo.tools\microsoft.dynamics.ax.application.devalm.buildxpp.10.0.605.10014.nupkg" -Source "Contoso"
```

This will push the package / nuget to the Azure DevOps feed.
The file that will be pushed / uploaded is identified by the Path "c:\temp\d365fo.tools\microsoft.dynamics.ax.application.devalm.buildxpp.10.0.605.10014.nupkg".
The request will be going to the Azure DevOps instance that is registered with the Source (Name) "Contoso" via the nuget.exe tool.

## PARAMETERS

### -Path
Path to the package / nuget that you want to push to the Azure DevOps feed

```yaml
Type: String
Parameter Sets: (All)
Aliases: PackagePath

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Source
The logical name for the nuget source / connection that you want to use while pushing the package / nuget

This requires you to register the nuget source, by hand, using the nuget.exe tool directly

Base command to use:
.\nuget sources add -Name "D365FO" -Source "https://pkgs.dev.azure.com/Contoso/DynamicsFnO/_packaging/D365Packages/NuGet/v3/index.json" -username "alice@contoso.dk" -password "uVWw43FLzaWk9H2EDguXMVYD3DaWj3aHBL6bfZkc21cmkwoK8X78"

Please note that the password is in fact a personal access token and NOT your real password

The value specified for Name in the nuget sources command, is the value to supply for Source for this cmdlet

```yaml
Type: String
Parameter Sets: (All)
Aliases: NugetSource, Destination

Required: False
Position: 2
Default value: None
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
Position: 3
Default value: $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\Nuget")
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

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts

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

## RELATED LINKS
