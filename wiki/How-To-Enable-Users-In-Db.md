# **Enable users in the D365FO environment**

This how-to will guide you on how to enable users in the database. This is required if you import a bacpac file that comes directly from a D365FO production instance, or if someone has disabled the users for others reasons.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **Enabling the users in the database**
We want to enable all NON-SYSTEM user accounts in the D365FO database, and that way allow them to logon to the D365FO environment. Type the following command:

```
Get-D365User -ExcludeSystemUsers | Enable-D365User
```

[[images/howtos/Enable-Users.gif]]

## **Closing comments**
In this how to we showed you how to enable all NON-SYSTEM user accounts in the D365FO database. After this operation all users are now enabled and capable of logging into the D365FO environment.