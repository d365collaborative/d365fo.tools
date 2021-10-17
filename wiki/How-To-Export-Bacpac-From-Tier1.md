# **Export a bacpac file from a Tier1 environment**

This how-to will guide you while you will be exporting a bacpac file from a Tier1 environment.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **Stop all D365FO services**
We need to stop all D365FO related services, to ensure that our database isn't being updated while we are exporting it. Type the following command:

```
Stop-D365Environment -All
```

[[images/howtos/Stop-Services.gif]]

## **Export bacpac file**
We will now export the bacpac file, and instruct the command to output the progress, so we can see that things are running as expected. Type the following command:

```
New-D365Bacpac -ExportModeTier1 -ShowOriginalProgress
```

[[images/howtos/Export-Bacpac.gif]]

The command will run for quite some time, but it will eventually exit and output the file location of the newly created bacpac file.

## **Closing comments**
In this how to we showed you how you can create a valid bacpac file from a Tier1 environment. The bacpac file is prepped for either other Tier1 environments, but is also valid for Tier2+ environments, through the LCS portal.
