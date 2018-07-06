<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ExecutionMode
Parameter description

.PARAMETER DatabaseServer
Parameter description

.PARAMETER DatabaseName
Parameter description

.PARAMETER SqlUser
Parameter description

.PARAMETER SqlPwd
Parameter description

.PARAMETER BackupDirectory
Parameter description

.PARAMETER NewDatabaseName
Parameter description

.PARAMETER BacpacDirectory
Parameter description

.PARAMETER BacpacName
Parameter description

.PARAMETER RawBacpacOnly
Parameter description

.EXAMPLE
New-BacPacv2 -ExecutionMode FromSql -DatabaseServer localhost -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1

.EXAMPLE
New-BacPacv2 -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1

.EXAMPLE
New-BacPacv2 -ExecutionMode FromAzure -DatabaseServer dbserver1.database.windows.net -DatabaseName db -SqlUser User123 -SqlPwd "Password123" -BacpacDirectory C:\Temp\Bacpac\ -BacpacName Testing1

.NOTES
General notes
#>
function New-BacPacv2 {
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

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 6 )]
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
    
    $sqlmode = $false
    $azuremode = $false

    $sqlPackagePath = $Script:SqlPackage

    if ([System.IO.File]::Exists($sqlPackagePath) -ne $True) {
        Write-Host "The sqlpackage.exe is not present on the system. This is an important part of making the bacpac file. Please install latest SQL Server Management Studio on the machine and run the cmdlet again. `r`nVisit this link:`r`ndocs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms" -ForegroundColor Yellow
        Write-Host "The sqlpackage.exe is expected to be found at this location: " -ForegroundColor Yellow 
        Write-Host $sqlPackagePath -ForegroundColor Yellow 
        Write-Error "The sqlpackage.exe is missing on the system." -ErrorAction Stop
    }

    $StartTime = Get-Date

    if ((Test-path $BackupDirectory) -eq $false) {$null = new-item -ItemType directory -path $BackupDirectory }
    if ((Test-path $BacpacDirectory) -eq $false) {$null = new-item -ItemType directory -path $BacpacDirectory }

    if ($ExecutionMode.ToLower() -eq "FromSql".ToLower()) {
        $sqlmode = $true
    }
    else {
        $azuremode = $true
    }

    if ($RawBacpacOnly.IsPresent) {
        Invoke-SqlPackage $DatabaseServer $DatabaseName $SqlUser $SqlPwd (Join-Path $BacpacDirectory "$BacpacName.bacpac")
    }
    else {
        $bacpacPath = (Join-Path $BacpacDirectory "$BacpacName.bacpac")

        if ($sqlmode) {
            Invoke-SqlBackupRestore $DatabaseServer $DatabaseName $SqlUser $SqlPwd $NewDatabaseName
            
            Invoke-ClearSqlSpecificObjects $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd 

            Invoke-SqlPackage $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd $bacpacPath

            Remove-Database -DatabaseServer $DatabaseServer -DatabaseName $NewDatabaseName -SqlUser $SqlUser -SqlPwd $SqlPwd

            $bacpacPath
        }
        else {
            Invoke-AzureBackupRestore $DatabaseServer $DatabaseName $SqlUser $SqlPwd $NewDatabaseName

            Invoke-ClearAzureSpecificObjects $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd 

            Invoke-SqlPackage $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd $bacpacPath

            Remove-Database -DatabaseServer $DatabaseServer -DatabaseName $NewDatabaseName -SqlUser $SqlUser -SqlPwd $SqlPwd

            $bacpacPath
        }
    }
}