# **LCS API Authentication**

The LCS (Lifecycle Services) API authentication will enable you to use the functionality provided by the LCS API.

This how-to will guide you on how to authenticate with the LCS API using the d365fo.tools and persist the LCS API details on your machine. This way you don't need to remember the finer details when you start using other cmdlets of the d365fo.tools that make use of the LCS API.

## **Prerequisites**
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session
* User account without MFA enabled
   * Should already be able to log into LCS and be part of the project
* Registered Application in the Azure AD
  * Needs to have the "Dynamics Lifecycle services" permission assigned and granted/consented
* LCS Project Id

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

To learn more about the prerequisites for this how-to, you should visit Adrià Ariste's [blog](https://ariste.info/en) - more specific the following [guide](https://ariste.info/en/msdyn365-azure-devops-alm), [chapter "Release Pipelines"](https://ariste.info/en/dynamics365almguide/setting-up-release-pipeline-in-azure-devops-for-dynamics-365-for-finance-and-operations/) & [chapter "LCS DB API"](https://ariste.info/en/dynamics365almguide/call-the-lcs-database-movement-api-from-your-azure-devops-pipelines/)

## **Configure LCS API access details**
For you to be able to communicate with the LCS API, you will need an username, password and a registered application. As mentioned in the prerequisites, you should read the blog post from Adrià Ariste.

The following script will:
1. Test that your username, password and registered application is working
2. Store the authentication token and registered application along with the LCS project id

```powershell
# We will start by testing that we can obtain a valid OAuth token, to make sure our details are correct
Get-D365LcsApiToken -ClientId "e70cac82-6a7c-4f9e-a8b9-e707b961e986" -Username "Lcs-Automation@contoso.com" -Password "fT1DHcLdeTWC9aumugHr" -LcsApiUri "https://lcsapi.lcs.dynamics.com"

# Now we are going to save the details, the refresh token, the registered application and the project id
Get-D365LcsApiToken -ClientId "e70cac82-6a7c-4f9e-a8b9-e707b961e986" -Username "Lcs-Automation@contoso.com" -Password "fT1DHcLdeTWC9aumugHr" -LcsApiUri "https://lcsapi.lcs.dynamics.com" | Set-D365LcsApiConfig -ProjectId "123456789" -ClientId "e70cac82-6a7c-4f9e-a8b9-e707b961e986"
```

[[images/howtos/Authenticate-LCS-API.gif]]

So now you will have the authentication token, the registered application and the project id persisted on your machine, which will enable different cmdlets to utilize them going forward.