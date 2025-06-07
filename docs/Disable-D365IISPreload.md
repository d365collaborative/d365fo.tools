# Disable-D365IISPreload
Disables IIS Preload for the AOSService application pool and website, reverting to default IIS settings.

## Synopsis
Configures IIS to:
- Set Application Pool Start Mode to OnDemand
- Set Idle Time-out to 20 minutes (default)
- Disable Preload on the AOSService website
- Set doAppInitAfterRestart to false (if Application Initialization is installed)

## Usage
```powershell
Disable-D365IISPreload
```

## Notes
- Requires administrative privileges.
- Based on [Denis Trunin's article](https://www.linkedin.com/pulse/enable-iis-preload-speed-up-restart-after-x-compile-denis-trunin-86j5c).
