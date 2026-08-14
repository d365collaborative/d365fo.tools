---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Disable-D365IISPreload

## SYNOPSIS
Disables IIS Preload for the AOSService application pool and website.

## SYNTAX

```
Disable-D365IISPreload [<CommonParameters>]
```

## DESCRIPTION
Reverts IIS Preload settings for the AOSService application:
- Sets Application Pool Start Mode to OnDemand
- Sets Idle Time-out to 0 (default)
- Disables Preload on the AOSService website
- Sets doAppInitAfterRestart to false (if Application Initialization is installed)
- Restores previous IIS Preload configuration from backup if available
- Restores or removes the initializationPage property as appropriate
- Uninstalls IIS Application Initialization feature if it was not installed in the backup

## EXAMPLES

### EXAMPLE 1
```
Disable-D365IISPreload
```

Disables IIS Preload for the AOSService application pool and website, restoring previous settings from backup if available.

## PARAMETERS

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

[Enable-D365IISPreload]()

