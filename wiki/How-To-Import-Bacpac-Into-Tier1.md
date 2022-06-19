# **Import a bacpac file into a Tier1 environment**

This how-to will guide you while you will be importing a bacpac file into a Tier1 environment.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session
* Valid bacpac file

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **Import bacpac file into the SQL Server**
We want to import the bacpac file into the SQL Server, and we want to do that into a new database. Type the following command:

```
Import-D365Bacpac -BacpacFile "C:\Temp\d365fo.tools\AxDB.bacpac" -ImportModeTier1 -NewDatabaseName GOLDEN
```

[[images/howtos/Import-Bacpac.gif]]

### Troubleshooting

If you get an error message during this step that complains about a missing `sqlpackage.exe`, run the following command before running the `Import-D365Bacpac` command again.

```
Invoke-D365InstallSqlPackage
```

## **Stop all D365FO services**
We need to stop all D365FO related services, to ensure that our D365FO database isn't being lock when we are going to update it. Type the following command:

```
Stop-D365Environment -All
```

[[images/howtos/Stop-Services.gif]]

## **Switch databases**
With the newly created GOLDEN database, we will be switching it in as the D365FO database. Type the following command:

```
Switch-D365ActiveDatabase -SourceDatabaseName GOLDEN
```

[[images/howtos/Switch-Database.gif]]

## **Synchronize the D365FO databases**
With the newly GOLDEN database switched in a the D365FO database, we need to ensure that the codebase and the database is synchronized correctly and fully working. Type the following command:

```
Invoke-D365DBSync -ShowOriginalProgress
```

[[images/howtos/Invoke-DBSync.gif]]

## **Start all D365FO services**
With the synchronization of the database completed, we need to start all D365FO related services again, to make the D365FO environment available again. Type the following command:

```
Start-D365Environment -All
```

[[/images/howtos/Start-Services.gif]]

## **Closing comments**
In this how to we showed you how you can update a Tier1 environment with a bacpac file, and how to make sure that the database is synchronized with the codebase. Depending on where you obtained the bacpac file from, you might need to [update](How-To-Update-Users-In-Db) and/or [enable](How-To-Enable-Users-In-Db) the users. Please refer to the How To section and learn how to complete either task.
