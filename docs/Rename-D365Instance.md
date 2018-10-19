---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Rename-D365Instance

## SYNOPSIS
Rename as D365FO Demo/Dev box

## SYNTAX

```
Rename-D365Instance [-NewName] <String> [[-AosServiceWebRootPath] <String>]
 [[-IISServerApplicationHostConfigFile] <String>] [[-HostsFile] <String>] [[-BackupExtension] <String>]
 [[-MRConfigFile] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Rename function, changes the config values used by a D365FO dev box for identifying its name.
Standard it is called 'usnconeboxax1aos'

## EXAMPLES

### EXAMPLE 1
```
Rename-D365Instance -NewName "Demo1"
```

This will rename the D365 for Finance & Operations instance to "Demo1".
This IIS will be restarted while doing it.

## PARAMETERS

### -NewName
The new name wanted for the D365FO instance

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AosServiceWebRootPath
Path to the webroot folder for the AOS service 'Default value : C:\AOSService\Webroot

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:AOSPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -IISServerApplicationHostConfigFile
Path to the IISService Application host file, \[Where the binding configurations is stored\] 'Default value : C:\Windows\System32\inetsrv\Config\applicationHost.config'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:IISHostFile
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostsFile
Place of the host file on the current system \[Local DNS record\] ' Default value C:\Windows\System32\drivers\etc\hosts'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:Hosts
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackupExtension
Backup name for all the files that are changed

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Bak
Accept pipeline input: False
Accept wildcard characters: False
```

### -MRConfigFile
Path to the Financial Reporter (Management Reporter) configuration file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Script:MRConfigFile
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Rasmus Andersen (@ITRasmus)
Author: Mötz Jensen (@Splaxi)

The function restarts the IIS Service.
Elevated privileges are required.

## RELATED LINKS
