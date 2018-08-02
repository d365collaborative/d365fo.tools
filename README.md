# **d365fo.tools**
Powershell module to handle the different management tasks during a Dynamics 365 Finace & Operations (D365FO)
Read more about D365FO on [docs.microsoft.com](https://docs.microsoft.com/en-us/dynamics365/unified-operations/fin-and-ops/index)

Available on Powershellgallery
[d365fo.tools](https://www.powershellgallery.com/packages/d365fo.tools)

## **Getting started**
### **Install the latest module**
```
Install-Module -Name d365fo.tools
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

## **Work with users**
### **Provision a new admin for a given instance**

```
Set-D365Admin "admin@contoso.com"
```

*Please remember that the username / e-mail has to be a valid Azure Active Directory*

### **Import a list of users into the environment**

```
Import-D365AadUser -Userlist "Claire@contoso.com;Allen@contoso.com"
```

*Imports Claire and Allen into the environment*

*Remeber that the list has to be semicolon (';') separated*


### **Update users in an environment after database migration / restore or re-provisioning**

```
Update-D365User -Email "claire@contoso.com"
```
*This will search for the user in the UserInfo table with "claire@contoso.com" e-mail address and update it with the needed details to get access to the environment*

### **Update users in an environment after database migration / restore or re-provisioning - advanced**

```
Update-D365User -Email "%contoso.com%"
```

*This will search for all users in the UserInfo table with the "contoso.com" text in their e-mail address and update them with the needed details to get access to the environment*

## **Work with bacpac files**

### **Generate a bacpac file from a Tier1 environment to be ready for a Tier2 environment**

```
New-D365Bacpac -ExecutionMode FromSql -DatabaseServer localhost -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1
```

*This will backup the db database from the localhost server.*

*It will restore the backup back into the localhost server with a new name "Testing1".*

*It will clean up the Testing1 database for objects that cannot exist in Azure DB.*

*It will start the sqlpackage.exe file and export a valid bacpac file.*

*It will delete the Testing1 database on the localhost server.*

### **Generate a bacpac file from a Tier2 environment. As an export / backup file only**

```
New-D365Bacpac -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1 -RawBacpacOnly
```

*This will export an bacpac file directly from the db database from the Azure db instance at dbserver1.database.windows.net.*

### **Generate a bacpac file from a Tier2 environment to be ready for a Tier1 environment**

```
New-D365Bacpac -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1
```

*This will create a copy of the db database in the Azure db instance at dbserver1.database.windows.net.*

*It will clean up the Testing1 database for objects that cannot exist in SQL Server.*

*It will start the sqlpackage.exe file and export a valid bacpac file.*

*It will delete the Testing1 database in the Azure db instance at dbserver1.database.windows.net.*


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
Invoke-D365AXUpdateInstaller -Path C:\DeployablePackages -GenerateImportExecute
```

*This will execute the generate, import and execute steps in correct order. The cmdlet expects one or more folders inside the "C:\DeployablePackages" location*

### **Installation of 3. party ISV module**
```
Invoke-D365AXUpdateInstaller -Path C:\DeployablePackages -DevInstall
```
*This will execute the **"devinstall"** mode. The cmdlet expects one or more folders inside the "C:\DeployablePackages" location*

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
