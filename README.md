# d365fo.tools
Powershell module to handle the different management tasks during a Dynamics 365 Finace & Operations (D365FO)
Read more about D365FO on [docs.microsoft.com](https://docs.microsoft.com/en-us/dynamics365/unified-operations/fin-and-ops/index)

Available on Powershellgallery
[d365fo.tools](https://www.powershellgallery.com/packages/d365fo.tools)

```
Install-Module -Name d365fo.tools
```

**List all available commands / functions**

```
Get-Command -Module d365fo.tools
```

**Update the module**

```
Update-Module -name d365fo.tools
```

The tool tries to assist you with a lot of the time consuming and/or cumbersome tasks during a project. E.g.

**Rename a local VM (onebox) to be accessible on a custom URL / URI.**

```
Rename-D365FO -NewName 'Demo1'
```

*Now the machine (iis) will only respond to request for https://demo1.cloud.onebox.dynamics.com*

**Change the start page of the browser to another URL / URI**

```
Set-StartPage -Name 'Demo1'
```

*Now when starting the browser you will start visit https://demo1.cloud.onebox.dynamics.com*

**Provision a new admin for a given instance**

```
Set-Admin "admin@contoso.com"
```

*Please remember that the username / e-mail has to be a valid Azure Active Directory*

**Import a list of users into the environment**

```
Import-AadUser -Userlist "Claire@contoso.com,Allen@contoso.com"
```

*Imports Claire and Allen into the environment*

**Generate a bacpac file from a Tier1 environment to be ready for a Tier2 environment**

```
New-BacPacv2 -ExecutionMode FromSql -DatabaseServer localhost -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1
```

*This will backup the db database from the localhost server.*

*It will restore the backup back into the localhost server with a new name "Testing1".*

*It will clean up the Testing1 database for objects that cannot exist in Azure DB.*

*It will start the sqlpackage.exe file and export a valid bacpac file.*

*It will delete the Testing1 database on the localhost server.*

**Generate a bacpac file from a Tier2 environment. As an export / backup file only**

```
New-BacPacv2 -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1
```

*This will export an bacpac file directly from the db database from the Azure db instance at dbserver1.database.windows.net.*

**Generate a bacpac file from a Tier2 environment to be ready for a Tier1 environment**

```
New-BacPacv2 -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BackupDirectory C:\Temp\backup\ -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1
```

*This will create a copy of the db database in the Azure db instance at dbserver1.database.windows.net.*

*It will clean up the Testing1 database for objects that cannot exist in SQL Server.*

*It will start the sqlpackage.exe file and export a valid bacpac file.*

*It will delete the Testing1 database in the Azure db instance at dbserver1.database.windows.net.*

**Upload a file to Azure Storage account**

```
Invoke-AzureStorageUpload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Filepath C:\temp\bacpac\UAT_20180701.bacpac -DeleteOnUpload
```

*This will upload the UAT_20180701.bacpac to the specified Azure Storage account and delete it when completed*

**List all the database connection details for an environment**

```
Get-DatabaseAccess
```

*This will show database connection details that D365FO is configured with.*

**Decrypt and store a copy of the web.config file from the AOS**

```
Get-DecryptedConfigFile -DropPath 'C:\Temp'
```

*This will store a decrypted web.config file at c:\temp*

**Rearm the Windows license / activation counter**

```
Invoke-ReArmWindows -Restart
```

*This will try to rearm the Windows license and will only work if you have retries left. Will restart afterwards.*

**Sync the database like Visual Studio**

```
Invoke-DBSync
```

*This utilizes the same mechanism as Visual Studio just in PowerShell and runs the entire synchronization process.* 

**Update users in an environment after database migration / restore or re-provisioning**

```
Update-User -Email "claire@contoso.com"
```
*This will search for the user in the UserInfo table with "claire@contoso.com" e-mail address and update it with the needed details to get access to the environment*

**Update users in an environment after database migration / restore or re-provisioning - advanced**

```
Update-User -Email "%contoso.com%"
```

*This will search for all users in the UserInfo table with the "contoso.com" text in their e-mail address and update them with the needed details to get access to the environment*

