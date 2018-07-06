<#
.SYNOPSIS
Creates a bacpac file based on the giving DatabaseName

.DESCRIPTION
The function backups the database, restores it, preps it for bacpacing.

.PARAMETER DatabaseServer
The Sql server

.PARAMETER DatabaseName
The database to create a bacpac file from 

.PARAMETER SqlUser
User with creation rights on the database server

.PARAMETER SqlPwd
Password for sqlUser

.PARAMETER BackupDirectory
The place to drop the bak file

.PARAMETER NewDatabaseName
The new name the backup should be restored as

.PARAMETER BacpacDirectory
The place to drop the bacpac

.PARAMETER AzureDB
The full connection string for an Azure DB instance. E.g. "<ServerName>.database.windows.net"

.PARAMETER BacpacName
The name of the bacpac file created

.PARAMETER CreateBacpacOnly
A switch to tell the cmdlet to run the entire process or just to do a bacpac export.

.EXAMPLE
New-BacPac -BackupDirectory "C:\Backup" -NewDatabaseName "BacPac" -BacpacDirectory "C:\Backup"

Will run the entire process with the informations from the active system. E.g. running from a onebox
and it will read the servername, databasename, sqluser and sqlpassword from config file. 

It will use the C:\backup path for holding the backup file and name the restored database "BacPac".

It will store the exported bacpac file in c:\Backup

.EXAMPLE
New-BacPac -BacpacName "BacPac" -BacpacDirectory "C:\Backup" -BacpacOnly

Will only run the export of a bacpac process with the informations from the active system. E.g. running from a onebox
and it will read the servername, databasename, sqluser and sqlpassword from config file. 

It will use the C:\backup path for holding the backup file and name the restored database "BacPac".

It will store the exported bacpac file in c:\Backup

.EXAMPLE
New-BacPac -AzureDB "LabAzureDB.database.windows.net" -DatabaseName "AxDB" -SqlUser "sqladmin" -SqlPwd "Password" -BacpacName "BacPac" -BacpacDirectory "C:\Backup" -BacpacOnly

Will only run the export of a bacpac process with the supplied parameters. Use it when you don't 
want depend on the information to be read from the system.

It will use the C:\backup path for holding the backup file and name the restored database "BacPac".

It will store the exported bacpac file in c:\Backup


.NOTES
General notes
#>
function New-BacPac {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]        
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnly', Position = 1 )]        
        [Alias('AzureDB')]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'BacpacOnly', Position = 2 )]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'BacpacOnly', Position = 3 )]        
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'BacpacOnly', Position = 4 )]        
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 5 )]
        [string]$BackupDirectory = "C:\Temp",

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 6 )]        
        [string]$NewDatabaseName,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 7 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'BacpacOnly' )]
        [string]$BacpacDirectory = "C:\Temp",      
                
        [Parameter(Mandatory = $false, ParameterSetName = 'BacpacOnly', Position = 1 )]        
        [string]$AzureDB = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'BacpacOnly', Position = 5 )]        
        [string]$BacpacName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'BacpacOnly' )]        
        [switch]$CreateBacpacOnly 
    )
    
    $command = $Script:SqlPackage

    if ([System.IO.File]::Exists($command) -ne $True) {
            Write-Host "The sqlpackage.exe is not present on the system. This is an important part of making the bacpac file. Please install latest SQL Server Management Studio on the machine and run the cmdlet again. `r`nVisit this link:`r`ndocs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms" -ForegroundColor Yellow
            Write-Error "The sqlpackage.exe is missing on the system." -ErrorAction Stop
    }

    $StartTime = Get-Date

    if ((Test-path $BackupDirectory) -eq $false) {$null = new-item -ItemType directory -path $BackupDirectory }
    if ((Test-path $BacpacDirectory) -eq $false) {$null = new-item -ItemType directory -path $BacpacDirectory }
    
    if (!$CreateBacpacOnly.IsPresent) {
        $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

        $commandText = get-content "$script:PSModuleRoot\internal\sql\add-bacpacdatabase.sql"
   
        $sqlCommand.CommandText = $commandText

        Write-Verbose "BackupDirectory is: $BackupDirectory"
        Write-Verbose "NewDatabaseName: $NewDatabaseName"

        $var = New-Object System.Data.SqlClient.SqlParameter("@CurrentDatabase", $DatabaseName)
        $null = $sqlCommand.Parameters.Add($var)

        $var = New-Object System.Data.SqlClient.SqlParameter("@NewName", $NewDatabaseName)
        $null = $sqlCommand.Parameters.Add($var)

        $var = New-Object System.Data.SqlClient.SqlParameter("@BackupDirectory", $BackupDirectory)
        $null = $sqlCommand.Parameters.Add($var)
   
        $sqlCommand.CommandTimeout = 0

        $sqlCommand.Connection.Open()

        Write-verbose $sqlCommand.CommandText
    
        $null = $sqlCommand.ExecuteNonQuery()
        $sqlCommand.Dispose()


        $sqlCommand = Get-SQLCommand $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd

        $commandText = get-content "$script:PSModuleRoot\internal\sql\clear-bacpacdatabase.sql"

        $sqlCommand.CommandText = $commandText

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()

        $sqlCommand.Dispose()

        $param = "/a:export /ssn:$DatabaseServer /sdn:$NewDatabaseName /tf:$BacpacDirectory\$NewDatabaseName.bacpac /p:CommandTimeout=1200 /p:VerifyFullTextDocumentTypesSupported=false"

        Remove-Item -Path "$BacpacDirectory\$NewDatabaseName.bacpac" -ErrorAction SilentlyContinue -Force

    }
    else {
        $param = "/a:export /ssn:$DatabaseServer /sdn:$DatabaseName /su:$SqlUser /sp:$SqlPwd /tf:$BacpacDirectory\$BacpacName.bacpac /p:CommandTimeout=1200 /p:VerifyFullTextDocumentTypesSupported=false /p:Storage=File"

        Remove-Item -Path "$BacpacDirectory\$BacpacName.bacpac" -ErrorAction SilentlyContinue -Force
    }

    

    Start-Process -FilePath $command -ArgumentList  $param  -NoNewWindow -Wait

    if (!$CreateBacpacOnly.IsPresent) {

        $sqlCommand = Get-SQLCommand $DatabaseServer "Master" $SqlUser $SqlPwd

        $commandText = get-content "$script:PSModuleRoot\internal\sql\remove-database.sql"
    
        $sqlCommand.CommandText = $commandText.Replace("@Database", "$NewDatabaseName")

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
        $sqlCommand.Dispose()
    }

    $EndTime = Get-Date

    $TimeSpan = NEW-TIMESPAN -End $EndTime -Start $StartTime

    Write-Host "Time Taken" -ForegroundColor Green
    Write-Host "$TimeSpan" -ForegroundColor Green

    "$BacpacDirectory\$NewDatabaseName.bacpac"
}
