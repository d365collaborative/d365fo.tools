---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Enable-D365IISPreload

## SYNOPSIS
Enables IIS Preload for the AOSService application pool and website.

## SYNTAX

```
Enable-D365IISPreload [[-BaseUrl] <String>] [<CommonParameters>]
```

## DESCRIPTION
Configures IIS to preload the AOSService application, improving startup time after X++ compile.
- Sets Application Pool Start Mode to AlwaysRunning
- Sets Idle Time-out to 0
- Enables Preload on the AOSService website
- Sets doAppInitAfterRestart to true (if Application Initialization is installed)
- Optionally sets the initializationPage to a custom base URL

## EXAMPLES

### EXAMPLE 1
```
Enable-D365IISPreload
```

This will enable IIS Preload and set the initializationPage using the automatically detected base URL.

### EXAMPLE 2
```
Enable-D365IISPreload -BaseUrl "https://usnconeboxax1aos.cloud.onebox.dynamics.com"
```

This will enable IIS Preload and set the initializationPage to https://usnconeboxax1aos.cloud.onebox.dynamics.com/?mi=DefaultDashboard

## PARAMETERS

### -BaseUrl
The base URL to use for the initializationPage setting in IIS Application Initialization.
If not provided, the function will attempt to determine the base URL automatically using Get-D365Url.
Example: https://usnconeboxax1aos.cloud.onebox.dynamics.com

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Florian Hopfner (FH-Inway)
Based on Denis Trunin's article "Enable IIS Preload to Speed Up Restart After X++ Compile" (https://www.linkedin.com/pulse/enable-iis-preload-speed-up-restart-after-x-compile-denis-trunin-86j5c)
Written with GitHub Copilot GPT-4.1, mostly in agent mode.
See commits for prompts.

## RELATED LINKS

[Get-D365IISPreload]()

[Disable-D365IISPreload]()

