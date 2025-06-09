---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365IISPreload

## SYNOPSIS
Gets IIS Preload status for the AOSService application pool and website.

## SYNTAX

```
Get-D365IISPreload [<CommonParameters>]
```

## DESCRIPTION
Returns the current IIS Preload configuration for the AOSService application:
- Application Pool Start Mode
- Idle Time-out
- Website Preload Enabled
- doAppInitAfterRestart (if Application Initialization is installed)

## EXAMPLES

### EXAMPLE 1
```
Get-D365IISPreload
```

Retrieves the IIS Preload configuration for the AOSService application pool and website.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
### A custom object containing the following properties:
### - AppPool: Name of the application pool (AOSService)
### - StartMode: Start mode of the application pool (e.g., AlwaysRunning)
### - IdleTimeout: Idle timeout of the application pool (e.g., 00:00:00)
### - Site: Name of the website (AOSService)
### - PreloadEnabled: Indicates if preload is enabled for the website (True/False)
### - DoAppInitAfterRestart: Indicates if doAppInitAfterRestart is enabled (if Application Initialization is installed)
### - PreloadPage: The initialization page configured for preload (if any)
### - IISApplicationInitFeature: State of the IIS Application Initialization feature (Installed/Not installed)
## NOTES
Author: Florian Hopfner (FH-Inway)
Based on Denis Trunin's article "Enable IIS Preload to Speed Up Restart After X++ Compile" (https://www.linkedin.com/pulse/enable-iis-preload-speed-up-restart-after-x-compile-denis-trunin-86j5c)
Written with GitHub Copilot GPT-4.1, mostly in agent mode.
See commits for prompts.

## RELATED LINKS

[Enable-D365IISPreload]()

[Disable-D365IISPreload]()

