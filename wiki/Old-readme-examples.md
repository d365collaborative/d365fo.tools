## **Provided as-is**
This page is a direct copy & paste of the old repository readme page. We have stored all the examples here as a courtesy. 

Some of the examples are out-dated, while others are still valid and might not made it into the comment based help for the cmdlet / function itself.

If you find any example here that you believe should be part of the comment based help, please create an issue and tell us. Or even better, create a Pull Request with the example against the repository.

### **Install without administrator privileges**
```
Install-Module -Name d365fo.tools -Scope CurrentUser
```
### **List all available commands / functions**

```
Get-Command -Module d365fo.tools
```

### **Update the module**

```
Update-Module -name d365fo.tools
```

### **Get product build numbers**

```
Get-D365ProductInformation
```

*Will list all build numbers available, application and platform*

### **Rename a local VM (onebox) to be accessible on a custom URL / URI.**

```
Get-D365InstanceName
```
*Displays the current instance registered on the machine. Run on a machine with the D365 AOS installed on to get an result*

```
Rename-D365Instance -NewName 'Demo1'
```

*Now the machine (iis) will only respond to request for https://demo1.cloud.onebox.dynamics.com*

### **Change the start page of the browser to another URL / URI**

```
Set-D365StartPage -Name 'Demo1'
```

*Now when starting the browser you will start visit https://demo1.cloud.onebox.dynamics.com*

## **Working with users**
### **Provision a new admin for a given instance**

```
Set-D365Admin "admin@contoso.com"
```

*Please remember that the username / e-mail has to be a valid Azure Active Directory*

### **Import a list of users into the environment**

```
Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com"
```

*Imports Claire and Allen into the environment*


### **Import a list of users into the environment based on Azure AD Group**

```
Import-D365AadUser -AadGroupName "D365 Users" -ForceExactAadGroupName
```

*Imports all users included into "D365 Users" Azure AD Group into the environnement*

*The ForceExactAadGroupName parameter force command to find the AD group by searching for the exact name*

### **Update users in an environment after database migration / restore or re-provisioning**

```
Update-D365User -Email "claire@contoso.com"
```
*This will search for the user in the UserInfo table with "claire@contoso.com" e-mail address and update it with the needed details to get access to the environment*

### **Update users in an environment after database migration / restore or re-provisioning - advanced**

```
Update-D365User -Email "*contoso.com"
```

*This will search for all users in the UserInfo table with the "contoso.com" text in their e-mail address and update them with the needed details to get access to the environment*

### **Enable users in an environment after database refresh from Prod to Sandbox**

```
Enable-D365User -Email "claire@contoso.com" 
```

*This will search for the user in the UserInfo table with "claire@contoso.com" e-mail address and set enable = 1 if they are not allready enabled, -verbose will show which users where updated*

### **Enable users in an environment after database refresh from Prod to Sandbox - advanced**

```
Enable-D365User -Email "*@contoso.com" 
```

*This will search for the user in the UserInfo table with the "@contoso.com" text in their e-mail address and set enable = 1 if they are not allready enabled, -verbose will show which users where updated*

### **Import an user as sysadmin**
```
Set-D365SysAdmin
```
*This will import the local administrator on the machine into the registered SQL Server.*

**Notes:*You will have to run from an elevated console if you want to avoid supplying username and password***

### **Delete an user**
```
Remove-D365User -Email "Claire@contoso.com"
```
*This will remove the user with the email address "Claire@contoso.com" and all the configured security roles.*

## **Work with bacpac files**

### **Generate a bacpac file from a Tier1 environment to be ready for a Tier2 environment**

```
New-D365Bacpac -ExportModeTier1 -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacFile C:\Temp\Bacpac\Testing1.bacpac
```

*This will backup the db database from the localhost server.*

*It will restore the backup back into the localhost server with a new name "Testing1".*

*It will clean up the Testing1 database for objects that cannot exist in Azure DB.*

*It will start the sqlpackage.exe file and export a valid bacpac file.*

*It will delete the Testing1 database on the localhost server.*

### **Generate a bacpac file from a Tier2 environment. As an export / backup file only**

```
New-D365Bacpac -ExportModeTier2 -DatabaseServer dbserver1.database.windows.net -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -BacpacFile C:\Temp\Bacpac\Testing1.bacpac -ExportOnly
```

*This will export an bacpac file directly from the db database from the Azure db instance at dbserver1.database.windows.net.*

### **Generate a bacpac file from a Tier2 environment to be ready for a Tier1 environment**

```
New-D365Bacpac -ExportModeTier2 -DatabaseServer dbserver1.database.windows.net -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacFile C:\Temp\Bacpac\Testing1.bacpac
```

*This will create a copy of the db database in the Azure db instance at dbserver1.database.windows.net.*

*It will clean up the Testing1 database for objects that cannot exist in SQL Server.*

*It will start the sqlpackage.exe file and export a valid bacpac file.*

*It will delete the Testing1 database in the Azure db instance at dbserver1.database.windows.net.*

### **Import bacpac file into Tier1**
```
Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase"
```
*This will import into the registered sql server and create a new **"ImportedDatabase"** database.*

*It will import the bacpac file **"C:\temp\uat.bacpac"** and prepare the database for D365.*

### **List all the database connection details for an environment**

```
Get-D365DatabaseAccess
```

*This will show database connection details that D365FO is configured with*

### **Decrypt and store a copy of the web.config file from the AOS**

```
Get-D365DecryptedConfigFile -DropPath 'C:\Temp'
```

*This will store a decrypted web.config file at c:\temp*

## **Working with Windows license / activation**
### **Get current activation status**
```
Get-D365WindowsActivationStatus
```

*This will get the current Windows license and activation status for the machine. It will show how many days left before expiration and how many ReArms there is left*

### **Re-arm the machine and restart it when done**
```
Invoke-D365ReArmWindows -Restart
```

*This will try to rearm the Windows license and will only work if you have retries left. Will restart afterwards.*



### **Sync the database like Visual Studio**

```
Invoke-D365DBSync
```

*This utilizes the same mechanism as Visual Studio just in PowerShell and runs the entire synchronization process.* 


## **Handling D365 environment**

### **Get current state of D365FO services of machine**
```
Get-D365Environment
```

*Will list the status of all D365 services on the local machine*

### **Get current state of D365 services on "TEST-SB-AOS-1" and "TEST-SB-AOS-2"**
```
Get-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2" -All
```

*Will list the status of all D365 services on the specified machines*

### **Stop all D365FO services on machine**
```
Stop-D365Environment
```

*Will stop all D365 services on the local machine. Will report current status for all services*

### **Stop all D365FO services on "TEST-SB-AOS-1" and "TEST-SB-AOS-2"**
```
Stop-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2" -All
```

*Will stop all D365 services on the the specified machines. Will report current status for all services*

### **Start all D365FO services on machine**
```
Start-D365Environment
```

*Will start all D365 services on the local machine. Will report current status for all services*

### **Start all D365FO services on "TEST-SB-AOS-1" and "TEST-SB-AOS-2"**

```
Start-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2" -All
```

*Will start all D365 services on the the specified machines. Will report current status for all services*

### **Get all exposed D365FO services**

```
Get-ExposedService -ClientId "YouClientIdFromAppRegistration" -ClientSecret "TheSecretFromTheAppRegistration"
```
Will return a json containing the exposed services of the D365FO.
It is possible to provide 

- Authority [Defaulted to current instance identity provider]
- D365FO [Defaulted to current D365FO Enviroment]

### **Create self-signed certificates and configure AOS WIF trusted authorities**
```
Initialize-D365TestAutomationCertificate
```
Creates a new self signed certificate for automated testing and reconfigures the AOS Windows Identity Foundation configuration to trust the certificate

## **Fix misc issues**
### **Get Offline Authentication Administrator Email**

```
Get-D365OfflineAuthenticationAdminEmail
```

*Will display the current registered account as Offline Authentication Administrator*

### **Set Offline Authentication Administrator Email**
```
Set-D365OfflineAuthenticationAdminEmail -Email "admin@contoso.com"

```

*Will update the Offline Authentication Administrator registration to "admin@contoso.com"*

### **Get ClickOnce configuration**
```
Get-D365ClickOnceTrustPrompt
```

*This will get the current ClickOnce trust prompt configuration on the machine*

### **Set ClickOnce configuration**
```
Set-D365ClickOnceTrustPrompt
```

*This will set the necessary ClickOnce trust prompt configuration on the machine*

### **Get the Deployable Packages cleanup retention **
```
Get-D365SDPCleanUp
```
*This will display the current retention that is configured on the server. 
If the result is empty it means that this has never been configured.*

### **Set the Deployable Packages cleanup retention **
```
Set-D365SDPCleanUp -NumberOfDays 10
```
*This either create or update the cleanup retention in the registry and set 
it to 10 days.*

***Notes: Please note that the Set-D365SDPCleanUp requires elevated permissions to work.***

## **Work with packages, label files, language and labels**

### **Get all installed packages on the machine**
```
Get-D365InstalledPackage
```
*Gets all installed packages on the system/machine*

### **Get installed package by searching for a name**
```
Get-D365InstalledPackage -Name "ApplicationSuite"
```
*Gets the "ApplicationSuite" package*

### **Get all label files for a installed package**

```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "en-US"
```
*Gets all the "en-US" resource / label files from the ApplicationSuite package*

### **Get label files by searching for a name**

```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "en-US" -Name "PRO"
```
*Gets the PRO resource / label file from the "ApplicationSuite" package with the language "EN-US"*

### **Get all label names and values from a label file**
```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "en-US" -Name "PRO" | Get-D365Label
```
*Gets all label details from the PRO resource / label file from the "ApplicationSuite" package with the language "EN-US"*

### **Get label details by searching for a name**
```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "*" -Name "PRO" | Get-D365Label -Name "@PRO505"
```
*Gets the "@PRO505" label details from the "PRO" resource / label file from the "ApplicationSuite" package, **across all languages***

### **Get label details by search for a value**
```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "en-US" | Get-D365Label -Value "*qty*" -IncludePath
```
*Gets all "en-US" labels where the value contains "*qty*" from the "ApplicationSuite" package, **across all resource / label files***

### **Execute SysFlushAod class**

```
Invoke-D365SysFlushAodCache
```
*Will execute a web call to the SysRunnerClass with the name SysFlushAod class and have the class executed*

### **Call the Table Browser**

```
Invoke-D365TableBrowser -TableName SalesTable -Company "USMF"

```
*Will call the Table Browser in the web browser and display all data from the SalesTable within the "USMF" company*

### **Execute runnable class**

```
Invoke-D365SysRunnerClass -ClassName SysDBInformation -Company USMF

```
*Will execute a web call to the SysRunnerClass with the SysDBInformation as the parameter and have the class executed against the USMF company*

## **Work with tables, fields and ids**
### **Look up table details by id**

```
Get-D365Table -Id 10347
```
*Will get the details for the table with the id 10347*

### **Look up table details by searching for a name**

```
Get-D365Table -Name CustTable
```
*Will get the details for the CustTable*

### **Look up field details by TableId**

```
Get-D365TableField -TableId 10347
```

*Will get all fields and details for these fields for the table with id 10347*

### **Look up field details by searching for a table name**

```
Get-D365TableField -TableName CustTable
```
*Will get all fields and details for these fields for the table CustTable*

### **Get field details by TableId and FieldId**
```
Get-D365TableField -TableId 10347 -FieldId 175
```
*Will get the details for the field with id 175 that belongs to the table with id 10347*

### **Get field details by TableId and by searching for a field name*

```
Get-D365TableField -TableId 10347 -Name "VAT*"
```
*Will get the details for all fields that fits the search "VAT*" that belongs to the table with id 10347*

### **Get field details by searching for a field name across all tables**
```
Get-D365TableField -Name AccountNum -SearchAcrossTables
```
*Will search for the AccountNum field across all tables.*

## **Working with Azure Storage account**

### **Get all files from an Azure Storage account**
```
Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles"
```

*Get all files stored inside the **"backupfiles"** container / blob in the **"miscfiles"** storage account*

### **Upload a file to an Azure Storage account**

```
Invoke-D365AzureStorageUpload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Filepath C:\temp\bacpac\UAT_20180701.bacpac -DeleteOnUpload
```

*This will upload the **"UAT_20180701.bacpac"** file to the specified Azure Storage Account and delete it when completed*

### **Download a file from an Azure Storage account**

```
Invoke-D365AzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -FileName "UAT_20180701.bacpac" -Path "c:\temp" 
```
*This will download the **"UAT_20180701.bacpac"** file from the Azure Storage Account and store it in "c:\temp\UAT_20180701.bacpac"*

## **Working with .NET classes and methods**
### **Get .NET class details by searching for a class name**
```
Get-D365DotNetClass -Name "ERText*"
```

*This will search across **all** assembly files (\*.dll) located in the package directory for any class that fits the search "**ERText\***"*

### **Get .NET class details by searching for a class name and searching for a file name**
```
Get-D365DotNetClass -Name "ERText*" -Assembly "*LocalizationFrameworkForAx.dll*"
```

*This will search across assembly files (\*.dll) that fits the search "\*LocalizationFrameworkForAx.dll\*", located in the package directory for any class that fits the search "**ERText\***"*

### **Get all methods available from an assembly**
```
Get-D365DotNetMethod -Assembly "C:\AOSService\PackagesLocalDirectory\ElectronicReporting\bin\Microsoft.Dynamics365.LocalizationFrameworkForAx.dll"
```

*This will search for all methods, across **all** classes, that exists inside the specified assembly file*

## **Working with installing binary updates, X++ hotfixes and 3. party ISV solutions**

### **Installation of binary updates**
```
Invoke-D365SDPInstall -Path C:\DeployablePackages -Command RunAll
```

*This will execute the generate, import and execute steps in correct order. The cmdlet expects the path "C:\DeployablePackages" to be the extracted directory from a package*

### **Installation of 3. party ISV module - DevInstall**
```
Invoke-D365SDPInstall -Path C:\DeployablePackages -DevInstall
```
*This will execute the **"devinstall"** mode. The cmdlet expects the path "C:\DeployablePackages" to be the extracted directory from a package*

### **Installation of 3. party ISV module - QuickInstall**
```
Invoke-D365SDPInstall -Path C:\DeployablePackages -QuickInstall
```
*This will execute the **"QuickInstall"** mode. The cmdlet expects the path "C:\DeployablePackages" to be the extracted directory from a package*


### **Installation of X++ hotfix**
```
Invoke-D365SCDPBundleInstall -Path "c:\temp\HotfixPackageBundle.axscdppkg"
```
*This will execute the **"install"** mode without tfs / vsts parameters.*

## **Working with maintenance mode**

### **Enable maintenance mode**
```
Enable-D365MaintenanceMode
```
*This will put the environment into maintenance mode / state. Normally used when changing license configuration.*

### **Disable maintenance mode**
```
Disable-D365MaintenanceMode
```
*This will put the environment back into operation mode / state. Normally used when changing license configuration.
**Note: You might need to stop and start your entire environment when done.***

## **Working with installed services and topology files**

### **Get all installed services**

```
Get-D365InstalledService
```
*This will get all the installed services based on the installation logs.
**Note: The cmdlet mimics the AxUpdateInstaller.exe -list command that also only reads the logs files***

### **Create a new topology file and update it with ALMService,AOSService,BIService**
```
New-D365TopologyFile -Path C:\Temp\DefaultTopologyData.xml -Services "ALMService","AOSService","BIService" -NewPath C:\temp\CurrentTopology.xml
```
*This will read the "DefaultTopologyData.xml" file and update it with ALMService, AOSService and BIService*

### **Create a new topology file based on installed services**
```
$Services = @(Get-D365InstalledService | ForEach-Object {$_.Servicename})
New-D365TopologyFile -Path C:\Temp\DefaultTopologyData.xml -Services $Services -NewPath C:\temp\CurrentTopology.xml
```
*This will read the "DefaultTopologyData.xml" file and update it with the list of services from Get-D365InstalledService output*

## **Working with hotfixes**
### **Get all installed hotfixes**
```
Get-D365InstalledHotfix
```
*This will get all installed hotfixes on the machine and display all relevant information*

### **Get all installed hotfixes for specific module**
```
Get-D365InstalledHotfix -Model "*retail*"
```
*This will get all installed hotfixes that relates to models with retail in their name on the machine and display all relevant information*

### **Get all installed hotfixes for specific module and with specific KB number**
```
Get-D365InstalledHotfix -Model "*retail*" -KB "*43*"
```
*This will get all installed hotfixes that relates to models with retail in their name and where the KB number must contain **"43"** on the machine and display all relevant information*

## **Working with models**
### **Import a model file**
```
Invoke-D365ModelUtil -Path c:\temp\ApplicationSuiteModernDesigns_App73.axmodel
```
*This will import the **"c:\temp\ApplicationSuiteModernDesigns_App73.axmodel"** into the environment.*

***Note: Please note that you have to compile the application and run a db sync afterwards.***

## **Working with environment configurations**
### **Initialize the D365FO.Tools configuration store**
```
Initialize-D365Config
```
*This will create the default configuration objects and set them to default values*

### **Add an environment configuration**
```
Add-D365EnvironmentConfig -Name "UAT" -URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com/?cmp=USMF" -Company "USMF"
```
*This will add en entry named **"UAT"** with the **URL** and **Company** parameters.*

***Notes: This is the minimum you need to enabled a personal workstation to utilize Invoke-D365TableBrowser or Invoke-D365SysRunnerClass***

### **Select an environment configuration as active**
```
Set-D365ActiveEnvironmentConfig -Name "UAT"
```
*This will get the environment details that is named UAT and put that into the active environment configuration.*

***Notes: You **MUST** restart the powershell session before using any cmdlets that depend on the configuration change.***

### **Enabling the workstation mode**
```
Set-D365WorkstationMode -Enabled $true
```
*This will configure the module to be capable of running some of the cmdlets from a personal workstation tha is not an D365 environment*

***Notes: You **MUST** restart the powershell session before using any cmdlets that depend on the configuration change.***

### **List all environment configurations**
```
Get-D365EnvironmentConfig
```
*This will show all stored environment configurations*

### **Get the active environment configuration**
```
Get-D365ActiveEnvironmentConfig
```
*This will the entire hashtable containing all the environment details*

### **Get the SqlPassword from the active environment configuration**
```
(Get-D365ActiveEnvironmentConfig).SqlPwd
```
*This will only return the SqlPwd value from the active configuration*

***Notes: On a Tier 2 MS hosted environment we actually load the SqlUser and SqlPassword into memory. So when calling cmdlets that require SqlUser and SqlPassword it is already filled out.***

## **Working with Azure Storage Account configuration**
### **Add an Azure Storage Account configuration**
```
Add-D365AzureStorageConfig -Name "UAT-Exports" -AccountId "1234" -AccessToken "dafdfasdfasdf" -Blob "testblob"
```
*This will add en entry named **"UAT-Exports"** with the AccountId **1234**, AccessToken **dafdfasdfasdf** and Blob **testblob** parameters.*

### **Select an Azure Storage Account configuration as active**
```
Set-D365ActiveAzureStorageConfig -Name "UAT-Exports"
```
*This will get the environment details that is named **UAT-Exports** and put that into the active Azure Storage Account configuration.*

***Notes: You **MUST** restart the powershell session before using any cmdlets that depend on the configuration change.***

### **List all Azure Storage Account configurations**
```
Get-D365AzureStorageConfig
```
*This will show all stored Azure Storage Account configurations*

### **Get the active Azure Storage Account configuration**
```
Get-D365ActiveAzureStorageConfig
```
*This will the entire hashtable containing all the Azure Storage Account details*

## **Working with AOT objects**
### **Search for all AxClasses in a package**
```
Get-D365AOTObject -ObjectType AxClass -Path "C:\AOSService\PackagesLocalDirectory\ApplicationFoundation"
```
*This will search for all AxClasses in the ApplicationFoundation package*

### **Search for specific AxClass in a package**
```
Get-D365AOTObject -Name "*flush*" -ObjectType AxClass -Path "C:\AOSService\PackagesLocalDirectory\ApplicationFoundation"
```
*This will search for all AxClasses in the ApplicationFoundation package that matches the search "\*flush\*"*
