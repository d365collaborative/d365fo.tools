# **Import the d365fo.tools module**

This tutorial will show you how to import the d365fo.tools on a machine where you already installed the d365fo.tools. 

You need to import / load the d365fo.tools module into PowerShell every time you need to use a command from it.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Start PowerShell (Run As Administrator)**
Locate the PowerShell icon, if you don't have it on your desktop or in the task pane, we can locate it in the Windows Start Menu. Search for it or type PowerShell.

You need to right click on the PowerShell icon and select the "Run As Administrator" option for the menu.

[[images/tutorials/First-Time-Start-PowerShell-Administrator.gif]]

## **Start PowerShell**
Locate the PowerShell icon, if you don't have it on your desktop or in the task pane, we can locate it in the Windows Start Menu. Search for it or type PowerShell.

[[images/tutorials/First-Time-Start-PowerShell-Non-Administrator.gif]]

## **Import module**
You need to import / load the #d365fo.to module into the current PowerShell console. Type the following command:

```
Import-Module -Name d365fo.tools
```

[[images/tutorials/Import-Module-Administrator.gif]]

## **Closing comments**
In this tutorial we showed you how to import the d365fo.tools into your PowerShell console.