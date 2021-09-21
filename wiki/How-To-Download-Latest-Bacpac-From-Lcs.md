
# **Download latest bacpac from LCS via AzCopy**

This how-to will guide you on how to utilize the LCS API and download the latest bacpac file via the AzCopy.exe, and showing you how to increase the download speed with a nice little trick.

- **TOC**
  * [**Prerequisites**](#--prerequisites--)
  * [**Configure Azure Storage Account**](#--configure-azure-storage-account--)
  * [**Configure LCS API access details**](#--configure-lcs-api-access-details--)
  * [**Download the lastest bacpac file from LCS via AzCopy**](#--download-the-lastest-bacpac-file-from-lcs-via-azcopy--)
  * [**Closing comments**](#--closing-comments--)
  
## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session
* AzCopy installed
  * https://github.com/d365collaborative/d365fo.tools/wiki/How-To-Install-AzCopy
* Azure Storage account
* Blob Container
* SAS token to Blob Container
   * To make the initial testing easier, it should be full permission
* User account without MFA enabled
   * Should already be able to log into LCS and be part of the project
* Registered Application in the Azure AD
  * Needs to have the "Dynamics Lifecycle services" permission assigned and granted/consented
* LCS Project Id

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

To learn more about the prerequisites for this how-to, you should visit Adrià Ariste's [blog](https://ariste.info/en) - more specific the following [post](https://ariste.info/en/msdyn365-azure-devops-alm), [section 5](https://ariste.info/en/msdyn365-azure-devops-alm/#Setup_Release_Pipelines) & [section 7](https://ariste.info/en/msdyn365-azure-devops-alm/#LCS_DB_API)

## **Configure Azure Storage Account**
To make things easier going forward, we will register your Azure Storage Account details and persist them on your machine. This way you don't need to remember the finer details, but can still utilize the increased transfer speed.

The following script will:
1. Add the connection details and store them
2. Show the newly added details
3. Configure the added details as the active configuration
   1. This will be persisted for the next time you load the module
4. List all files/blobs that are already inside your container
   
```powershell
#We'll start with adding and storing the connection details for the Azure Storage Account
Add-D365AzureStorageConfig -Name "TestAccount" -AccountId "motz" -Container "demo" -SAS "?sv=2018-03-28&si=full&sr=c&sig=N3vCp95UUhlpdBxL5QZCjOrp0o30Yxdj17PJ70nxMc4%3D"

#Let's see the details we just saved
Get-D365AzureStorageConfig

#Now we are going to set the config as the active
Set-D365ActiveAzureStorageConfig -Name "TestAccount"

#Do we have anything in it already?
Get-D365AzureStorageFile
```

[[images/howtos/01.00-LCS-API-Add-D365AzureStorageConfig.gif]]

So now you will have an Azure Storage Account and its configuration details persisted on your machine, which will enable different cmdlets to utilize it going forward.

## **Configure LCS API access details**
For you to be able to communicate with the LCS API, you will need an username, password and a registered application. As mentioned in the prerequisites, you should read the blog post from Adrià Ariste.

To make things easier going forward, we will also register your LCS API details and persist them on your machine. This way you don't need to remember the finer details, when we start calling different cmdlets.

The following script will:
1. Test that your username, password and registered application is working
2. Store the refresh token and registered application along with the LCS project id
3. List all available bacpacs and backups from the LCS Asset Library
4. List the latest bacpac / backup from the LCS Asset Library

```powershell
#We'll start by testing that we can obtain a valid OAuth token, to make sure our details are correct
Get-D365LcsApiToken -ClientId "e70cac82-6a7c-4f9e-a8b9-e707b961e986" -Username "Lcs-Automation@contoso.com" -Password "fT1DHcLdeTWC9aumugHr" -LcsApiUri "https://lcsapi.lcs.dynamics.com"

#Now we are going to save the details, the refresh token, the registered application and the project id
Get-D365LcsApiToken -ClientId "e70cac82-6a7c-4f9e-a8b9-e707b961e986" -Username "Lcs-Automation@contoso.com" -Password "fT1DHcLdeTWC9aumugHr" -LcsApiUri "https://lcsapi.lcs.dynamics.com" | Set-D365LcsApiConfig -ProjectId "123456789" -ClientId "e70cac82-6a7c-4f9e-a8b9-e707b961e986"

#A simple test - let's see if we have any backups available?
Get-D365LcsDatabaseBackups

#And let's make sure we can get the latest bacpac only
Get-D365LcsDatabaseBackups -Latest
```

[[images/howtos/01.01-LCS-API-Get-D365LcsApiToken.gif]]

So now you will have the refresh token, the registered application and the project id persisted on your machine, which will enable different cmdlets to utilize them going forward.

## **Download the lastest bacpac file from LCS via AzCopy**
AzCopy is capable of working with different Azure Storage components / services, and the backend of the LCS Asset Library is in fact an Azure Storage Account, with some containers. One of the major capabilities of AzCopy, is that it can facilitate a transfer between 2 isolated Azure Storage Accounts, as long as you provide a complete Url/Uri, including a SAS token.

Whenever you list backups from the LCS API, the output will always contain a complete url for the specific file, containing a SAS token.

Because you have saved the configuration details for our own Azure Storage Account, we are also capable of generating a complete Url/Uri, containing a SAS token.

You need to concatenate the full URL/URI for you own Azure Storage Account, the container name, the desired destination filename and the SAS token that you must have in place for the container.

The following script will:
1. Generate a complete Url/Uri, containing a SAS token
2. Start the transfer of the latest bacpac file and into our own
3. List all available bacpacs and backups from the LCS Asset Library
4. List the latest bacpac / backup from the LCS Asset Library

```powershell
#With the Azure Storage Account persisted, we can now generate a complete Url/Uri
Get-D365AzureStorageUrl

#Let's us connect the dots and utilize the Azure Storage Account to speed up the download
#Generate complete Url/Uri
$TempDestination = Get-D365AzureStorageUrl -OutputAsHashtable

#Transfer the latest bacpac file from LCS to our own Azure Storage Account
$BlobParms = Get-D365LcsDatabaseBackups -Latest | Invoke-D365AzCopyTransfer @TempDestination -FileName "Latest.bacpac"

#Let's see if we really got the bacpac file transferred into our own Azure Storage Account
Get-D365AzureStorageFile

#Transfer the bacpac file from our Azure Storage Account and onto our machine.
$BlobParms | Invoke-D365AzCopyTransfer -DestinationUri "C:\Temp" -DeleteOnTransferComplete

#Let's see if we removed the temporary file from our Azure Storage Account
Get-D365AzureStorageFile
```

[[images/howtos/01.02-LCS-API-Get-D365LcsDatabaseBackups.gif]]

So now you will have the latest bacpac file downloaded onto your own machine, while removing the temporary file from the Azure Storage Account.

## **Closing comments**
In this how to we showed you how to utilize the AzCopy.exe as a tool to speed up the download process of files stored in the LCS Storage Account. You learned how to persist the Azure Storage Account details, along with the refresh token, register application and the LCS project id.