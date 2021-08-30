# **Import external users into the D365FO environment**

This how-to will guide you on how to import external users into your D365 environment.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **Import an external user into the database**
We are going to import a single user account into the D365FO database. The sign-in name / e-mail has to be the primary sign-in name of the account. Type the following command:

**Note:** You will need to fill in the id and the name which the account should have in the database, because we can't look that up with this command.

```
Import-D365ExternalUser -Id test -Name test -Email test@e-s.dk
```

[[images/howtos/Import-ExternalUser.gif]]

## **Closing comments**
In this how to we showed you how to import an external user into the D365FO database.