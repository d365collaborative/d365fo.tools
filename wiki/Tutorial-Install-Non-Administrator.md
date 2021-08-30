# **Install as a non-Administrator**

This tutorial will show you how to install the d365fo.tools on a machine where you **don't** have administrator access / privileges. 

If you are able to logon to the machine as an administrator, you should be using the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) tutorial instead.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* Internet access / Internet connection

## **Logon to the computer**
You need sign into the machine where you want to install the tools.

If you have an user account with administrator privileges, please follow the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) tutorial instead.

## **Start PowerShell**
Locate the PowerShell icon, if you don't have it on your desktop or in the task pane, we can locate it in the Windows Start Menu. Search for it or type PowerShell.

[[images/tutorials/First-Time-Start-PowerShell-Non-Administrator.gif]]

## **Install the d365fo.tools module**
In the PowerShell console/window type the following command:

```
Install-Module -Name d365fo.tools -Scope CurrentUser
```
[[images/tutorials/First-Time-Install-Non-Administrator-Install-Module.gif]]

PowerShell will now connect to the internet and try to download the latest version of the d365fo.tools and its dependencies. If your machine or PowerShell installation is all fresh, you might be prompted for questions / confirmations about core PowerShell configurations.

You need to either accept or approve all the prompts, for things to work like expected. See below examples on the which prompts you can expect and what response you should fill in.

### **NuGet**
If you want to learn about NuGet as concept, you can start here: https://en.wikipedia.org/wiki/NuGet

Answer the prompt with: **Y**

[[images/tutorials/First-Time-Install-Non-Administrator-Confirm-Nuget.gif]]

### **Untrusted Repository**
The tools are available from PowerShellGallery. If you want to learn about PowerShellGallery, you can start here: https://docs.microsoft.com/en-us/powershell/scripting/gallery/overview?view=powershell-5.1

Answer the prompt with: **A**

[[images/tutorials/First-Time-Install-Non-Administrator-Confirm-Repository.gif]]

## **Completing installation**
[[images/tutorials/First-Time-Install-Non-Administrator-Wait-For-Installation.gif]]

## **Import module**
While you just installed the d365fo.tools on the machine by following this tutorial, you will need to import or simply put, load the module into the PowerShell console, before you can use it. Type the following command:

```
Import-Module -Name d365fo.tools
```

[[images/tutorials/First-Time-Install-Non-Administrator-Import-Module.gif]]

## **Closing comments**
In this tutorial we showed you how to install the d365fo.tools when you **don't** have administrator privileges on machine. We highlighted some of the prompts that you might face on a freshly installed machine.