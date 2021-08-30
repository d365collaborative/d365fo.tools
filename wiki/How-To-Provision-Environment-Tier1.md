# **Provision D365FO environment to new Azure AD tenant**

This how-to will guide you on how to provision Tier1 environment to be connected to new Azure AD tenant.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session
* Valid Azure AD user account that should be assigned as the D365FO administrator

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **Provision user to the new D365FO administrator in the database**
For us to provision the Tier1 environment to be connected to a new Azure AD tenant, we need to change the administrator of the D365FO instance. Type the following command:

Please note that the value for the AdminSignInName parameter should be a user account using it **primary** domain. Replace "test@e-s.dk" with the user account you want to use.

```
Set-D365Admin -AdminSignInName test@e-s.dk
```

[[images/howtos/Provision-Admin.gif]]

### **Troubleshooting**
You might face an error while trying to provision the new administrator. This issue is connected to the Batch service running. We have seen several issues where we are unable to stop the service with the normal tools available, even standard Windows tools. We have seen 2 ways to fix this issue: First option is a simple restart of the entire machine and straight after the reboot try doing it again. Second option is to kill the Batch service using the Task Manager.

## **Closing comments**
In this how to we showed you how to can provision the D365FO environment to a new Azure AD tenant, by switching out the D365FO administrator.

If the environment has external users imported already, you will need to follow the **How-To-Update-Users** how to before they can access the environment.