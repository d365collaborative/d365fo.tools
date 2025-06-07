# Enable-D365IISPreload
Enables IIS Preload for the AOSService application pool and website to speed up application startup after X++ compile.

## Synopsis
Configures IIS to:
- Set Application Pool Start Mode to AlwaysRunning
- Set Idle Time-out to 0
- Enable Preload on the AOSService website
- Set doAppInitAfterRestart to true (if Application Initialization is installed)

## Usage
```powershell
Enable-D365IISPreload
```

## Notes
- Requires administrative privileges.
- Based on [Denis Trunin's article](https://www.linkedin.com/pulse/enable-iis-preload-speed-up-restart-after-x-compile-denis-trunin-86j5c).
