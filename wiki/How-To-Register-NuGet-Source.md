# **Register NuGet source**

This how-to will guide you on how to registered a NuGet source to be used with some of the cmdlets from the #d365fo.tools module.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session
* NuGet installed (via Invoke-D365InstallNuget)
* Valid Personal Access Token (PAT) obtained from the Azure DevOps project your Azure DevOps feed is hosted
* Correctly formatted feed url for the Azure DevOps feed your want to work against

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [How To Install NuGet](https://github.com/d365collaborative/d365fo.tools/wiki/How-To-Install-NuGet) tutorial to see how the d365fo.module can install the latest version of NuGet.

Please visit the [Use personal access tokens](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page) official guide to see how to create a PAT in Azure DevOps. Please note you need only Packaging (Read, Write & Manage).

A correctly formatted feed url is like:
https://pkgs.dev.azure.com/OrganizationName/ProjectName/_packaging/FeedName/NuGet/v3/index.json

Where you need to fill in the **OrganizationName** - **ProjectName** - **FeedName** details. E.g.
https://pkgs.dev.azure.com/Contoso/DynamicsFnO/_packaging/D365Packages/nuget/v3/index.json

## **Register NuGet source**
Either locate the local install location of NuGet, or registered it in your environment path variables. If installed via the Invoke-D365InstallNuGet it will default be located **"C:\Temp\d365fo.tools\NuGet"**. Type the following command:

```powershell
cd "C:\Temp\d365fo.tools\NuGet"
```

Now you need the PAT from your Azure DevOps Project. This will be stored on the local machine, so please be advised that you shouldn't do this on machines that you don't trust. Type the following command:

```powershell
.\nuget sources add -Name "D365FO" -Source "https://pkgs.dev.azure.com/Contoso/DynamicsFnO/_packaging/D365Packages/NuGet/v3/index.json" -username "alice@contoso.dk" -password "uVWw43FLzaWk9H2EDguXMVYD3DaWj3aHBL6bfZkc21cmkwoK8X78"
```

## **Closing comments**
In this how to we showed you how to register a local NuGet source on your machine. This enables you to have different sources registered on the same machine, so updating multiple customer projects should be made simpler. The name used for the source is to be used with `Invoke-D365AzureDevOpsNuGetPush` when it needs to push new packages to the Azure DevOps feed.