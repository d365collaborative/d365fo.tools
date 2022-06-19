# **Import users into the D365FO environment**

This how-to will guide you on how to import users into your D365 environment.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session
* Valid Azure AD user account capable of signing into Office365

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **Import an user into the database**
We are going to import a single user account into the D365FO database. The user has to be licensed with an valid Office365 mailbox. The sign-in name / e-mail has to be the primary sign-in name of the account. Type the following command:

**Note:** You need an account capable of signing into Office365, which will resolve the user account that you importing. The account that you're importing **can** be the same as the account you're signing in with.

```
Import-D365AadUser -Users test@e-s.dk
```

[[images/howtos/Import-AadUser.gif]]

## **Closing comments**
In this how to we showed you how to import an Azure AD user into the D365FO database.