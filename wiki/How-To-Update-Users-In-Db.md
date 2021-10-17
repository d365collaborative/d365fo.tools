# **Update users in the D365FO environment**

This how-to will guide you on how to update all NON-SYSTEM users in the database. This is required if you provision your D365FO environment to be connected to a new Azure AD tenant.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **Update the users in the database**
We want to update all NON-SYSTEM user accounts in the D365FO database, and that way allow them to logon to the D365FO environment. Type the following command:

```
Get-D365User -ExcludeSystemUsers | Update-D365User
```

[[images/howtos/Update-Users.gif]]

## **Closing comments**
In this how to we showed you how to update all NON-SYSTEM user accounts in the D365FO database. After this operation all users are now updated with their provider matching the Azure AD tenant of the D365FO environment.