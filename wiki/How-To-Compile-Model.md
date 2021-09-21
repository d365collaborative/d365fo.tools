# **Compile module**

This how-to will guide you on how to compile a module without using Visual Studio.

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


## **Search for modules / models**
To limit the output of modules in the console, you can utilize the search functionality in the `Get-D365Module` cmdlet. Type the following command:

```
Get-D365Module -Name *Project*
```

[[images/howtos/Get-Modules-Search.gif]]


## **Compile module / model**
We need to know the name of the module / model that we want to compile, and provide that as a parameter. Type the following command:

```
Invoke-D365ModuleFullCompile -Module Project
```

[[images/howtos/Compile-Single-Module.gif]]


## **Compile multiple modules / models**
We can utilize the `Get-D365Module` cmdlet and its output to the PowerShell pipeline, to supply the needed parameters to the `Invoke-D365ModuleFullCompile` cmdlet. Type the following command:

```
Get-D365Module -Name *Project* | Invoke-D365ModuleFullCompile
```

[[images/howtos/Compile-Modules.gif]]

## **Closing comments**
In this how to we showed you how to compile a specific module / model in a D365FO environment. We also showed you how to combine the `Get-D365Module` cmdlet with the `Invoke-D365ModuleFullCompile` cmdlet to make it easier to compile multiple modules / models.