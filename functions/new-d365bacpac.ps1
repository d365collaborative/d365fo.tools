<#
.SYNOPSIS
Generate a bacpac file from a database

.DESCRIPTION
Takes care of all the details and steps that is needed to create a valid bacpac file to move between Tier 1 (onebox or Azure hosted) and Tier 2 (MS hosted), or vice versa

Supports to create a raw bacpac file without prepping. Can be used to automate backup from Tier 2 (MS hosted) environment

.PARAMETER ExecutionMode
Tell what source database you want to work against. Depending on whether the source database is a classic SQL or Azure DB, the script has to execute different logic.

.PARAMETER DatabaseServer
The name of the database server

If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).

If Azure use the full address to the database server, e.g. server.database.windows.net

.PARAMETER DatabaseName
The name of the database

.PARAMETER SqlUser
The login name for the SQL Server instance

.PARAMETER SqlPwd
The password for the SQL Server user.

.PARAMETER BackupDirectory
The path where to store the temporary backup file when the script needs to handle that

.PARAMETER NewDatabaseName
The name for the database the script is going to create when doing the restore process

.PARAMETER BacpacDirectory
The path where to store the bacpac file that will be generated

.PARAMETER BacpacName
The filename of the bacpac file that will be generate - without extension

.PARAMETER RawBacpacOnly
Switch to instruct the cmdlet to either just create a dump bacpac file or run the prepping process first

.EXAMPLE
New-D365BacPac -ExecutionMode FromSql -DatabaseServer localhost -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1

Will backup and restore the db database again the localhost server.
Will run the prepping process against the restored database.
Will export a bacpac file.
Will delete the restored database.

.EXAMPLE
New-D365BacPac -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1

Will create a copy the db database on the dbserver1 in Azure.
Will run the prepping process against the copy database.
Will export a bacpac file.
Will delete the copy database.

.EXAMPLE
New-D365BacPac -ExecutionMode FromAzure -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1

Normally used for a Tier-2 export and preparation for Tier-1 import

Will create a copy the registered D365 database on the registered D365 Azure SQL Server.
Will run the prepping process against the copy database.
Will export a bacpac file.
Will delete the copy database.


.EXAMPLE
New-D365BacPac -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1 -RawBacpacOnly

Will export a bacpac file.
The bacpac should be able to restore back into the database without any preparing because it is coming from the environment from the beginning

.NOTES

#>
function New-D365BacPac {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'RawBacpacOnly', Position = 1 )]
        [ValidateSet('FromSql', 'FromAzure')]
        [string] $ExecutionMode = 'FromSql',

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'RawBacpacOnly', Position = 2 )]
        [Alias('AzureDB')]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'RawBacpacOnly', Position = 3 )]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'RawBacpacOnly', Position = 4 )]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 5 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'RawBacpacOnly', Position = 5 )]
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 6 )]
        [string]$BackupDirectory = "C:\Temp",

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 7 )]
        [string]$NewDatabaseName,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 8 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'RawBacpacOnly' )]
        [string]$BacpacDirectory = "C:\Temp",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 9 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'RawBacpacOnly', Position = 6 )]
        [string]$BacpacName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'RawBacpacOnly' )]
        [switch]$RawBacpacOnly

    )

    if (!$script:IsAdminRuntime -and !($PSBoundParameters.ContainsKey("SqlPwd"))) {
        Write-Host "It seems that you ran this cmdlet non-elevated and without the -SqlPwd parameter. If you don't want to supply the -SqlPwd you must run the cmdlet elevated (Run As Administrator) or simply use the -SqlPwd parameter" -ForegroundColor Yellow
        Write-Error "Running non-elevated and without the -SqlPwd parameter. Please run elevated or supply the -SqlPwd parameter." -ErrorAction Stop
    }

    $sqlMode = $false

    $sqlPackagePath = $Script:SqlPackage

    if ([System.IO.File]::Exists($sqlPackagePath) -ne $True) {
        Write-Host "The sqlpackage.exe is not present on the system. This is an important part of making the bacpac file. Please install latest SQL Server Management Studio on the machine and run the cmdlet again. `r`nVisit this link:`r`ndocs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms" -ForegroundColor Yellow
        Write-Host "The sqlpackage.exe is expected to be found at this location: " -ForegroundColor Yellow
        Write-Host $sqlPackagePath -ForegroundColor Yellow
        Write-Error "The sqlpackage.exe is missing on the system." -ErrorAction Stop
    }

    if ((Test-path $BackupDirectory) -eq $false) {$null = new-item -ItemType directory -path $BackupDirectory }
    if ((Test-path $BacpacDirectory) -eq $false) {$null = new-item -ItemType directory -path $BacpacDirectory }

    if ($ExecutionMode.ToLower() -eq "FromSql".ToLower()) {
        $sqlMode = $true
    }

    $bacpacPath = (Join-Path $BacpacDirectory "$BacpacName.bacpac")

    if ($RawBacpacOnly.IsPresent) {
        Write-Verbose "Invoking the export of the bacpac file only."
        Invoke-SqlPackage $DatabaseServer $DatabaseName $SqlUser $SqlPwd (Join-Path $BacpacDirectory "$BacpacName.bacpac")

        $bacpacPath
    }
    else {
        if ($sqlMode) {
            Write-Verbose "Invoking the SQL backup & restore process"
            Invoke-SqlBackupRestore $DatabaseServer $DatabaseName $SqlUser $SqlPwd $NewDatabaseName

            Write-Verbose "Invoking the SQL clear objects"
            Invoke-ClearSqlSpecificObjects $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd

            Write-Verbose "Invoking the export of the bacpac file from SQL"
            Invoke-SqlPackage $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd $bacpacPath

            Write-Verbose "Invoking the remove database from SQL"
            Remove-D365Database -DatabaseServer $DatabaseServer -DatabaseName $NewDatabaseName -SqlUser $SqlUser -SqlPwd $SqlPwd

            $bacpacPath
        }
        else {
            Write-Verbose "Invoking the creation of Azure DB copy"
            Invoke-AzureBackupRestore $DatabaseServer $DatabaseName $SqlUser $SqlPwd $NewDatabaseName

            Write-Verbose "Invoking the Azure clear objects"
            Invoke-ClearAzureSpecificObjects $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd

            Write-Verbose "Invoking the export of the bacpac file from Azure"
            Invoke-SqlPackage $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd $bacpacPath

            Write-Verbose "Invoking the remove database from Azure"
            Remove-D365Database -DatabaseServer $DatabaseServer -DatabaseName $NewDatabaseName -SqlUser $SqlUser -SqlPwd $SqlPwd

            $bacpacPath
        }
    }
}