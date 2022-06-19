# **Install AzCopy**

This how-to will guide you on how to install the latest available AzCopy onto your machine.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **Install latest AzCopy**
Installation of the latest AzCopy is done with the `Invoke-D365InstallAzCopy` cmdlet. Using this command will also update the internal path inside the module pointing to the AzCopy.exe. Type the following command:

```
Invoke-D365InstallAzCopy
```

[[images/howtos/Invoke-InstallAzCopy.gif]]

## **Closing comments**
In this how to we showed you how to install the latest AzCopy on your machine. By using the `Invoke-D365InstallAzCopy` cmdlet, you also updated the path for the module where to look for AzCopy.exe. If you just want to update the path for the AzCopy.exe, you can look into the `Set-D365AzCopyPath` cmdlet.