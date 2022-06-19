# **Start, Stop and List services**

This how to will guide you on how to manage the different D365FO services on a machine.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **List all available D365FO services**
If you want to see the entire list of D365FO services and/or see their current running state, type the following command:

```
Get-D365Environment -All
```

### **Output while services are running**

[[images/howtos/Get-Services-While-Running.gif]]

### **Output while services are stopped**

[[images/howtos/Get-Services-While-Stopped.gif]]

## **Stop all D365FO services**
If you want to stop all services on the machine, maybe you want to install an update or import a model, type the following command:

```
Stop-D365Environment -All
```

[[images/howtos/Stop-Services.gif]]

## **Start all D365FO services**
If you want to start all services on the machine, type the following command:

```
Start-D365Environment -All
```

[[images/howtos/Start-Services.gif]]

## **Restart all D365FO services**
If you want to restart all services on the machine, maybe because you are having some issues with caching, type the following command:

```
Restart-D365Environment -All
```

[[images/howtos/Restart-Services.gif]]

## **Closing comments**
In this how to we showed you how to use the d365fo.tools module to manage the different D365FO specific services.