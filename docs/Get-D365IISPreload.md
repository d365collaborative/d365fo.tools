# Get-D365IISPreload
Gets the IIS Preload status for the AOSService application pool and website.

## Synopsis
Returns the current IIS Preload configuration for the AOSService application:
- Application Pool Start Mode
- Idle Time-out
- Website Preload Enabled
- doAppInitAfterRestart (if Application Initialization is installed)

## Usage
```powershell
Get-D365IISPreload
```

## Output
Returns a PowerShell object with the following properties:
- AppPool
- StartMode
- IdleTimeout
- Site
- PreloadEnabled
- DoAppInitAfterRestart

## Notes
- Requires administrative privileges.
- Based on [Denis Trunin's article](https://www.linkedin.com/pulse/enable-iis-preload-speed-up-restart-after-x-compile-denis-trunin-86j5c).
