# **List modules / models**

This how-to will guide you on how to list and search for modules / models.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **List all modules / models**
Listing all installed modules / models can help you while troubleshooting your environment. Type the following command:

```
Get-D365Module
```

[[images/howtos/Get-Modules.gif]]


## **List all modules / models**
To limit the output of modules in the console, you can utilize the search functionality in the `Get-D365Module` cmdlet. Type the following command:

```
Get-D365Module -Name *Project*
```

[[images/howtos/Get-Modules-Search.gif]]

## **Closing comments**
In this how to we showed you how to list all modules / models in a D365FO environment. We also showed how the cmdlet also supports searching capabilities, to limit the output of modules / models.