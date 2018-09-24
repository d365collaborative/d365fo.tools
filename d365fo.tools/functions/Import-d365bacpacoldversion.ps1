<#
.SYNOPSIS
Import a bacpac file

.DESCRIPTION
Function used for importing a bacpac file into a Tier 2 environment

.PARAMETER DatabaseServer
The complete server name

.PARAMETER DatabaseName
The original databaseName

.PARAMETER SqlUser
Sql server with access to create a new Database

.PARAMETER SqlPwd
Password for the SqlUser

.PARAMETER BacpacFile
Location of the Bacpac file

.PARAMETER NewDatabaseName
Name for the imported database

.PARAMETER AxDeployExtUserPwd
Password for the user

.PARAMETER AxDbAdminPwd
Password for the user

.PARAMETER AxRuntimeUserPwd
Password for the user

.PARAMETER AxMrRuntimeUserPwd
Password for the user

.PARAMETER AxRetailRuntimeUserPwd
Password for the user

.PARAMETER AxRetailDataSyncUserPwd
Password for the user

.EXAMPLE
Import-D365BacpacOldVersion -SqlUser "sqladmin" -SqlPwd "XxXx" -BacpacFile "C:\temp\uat.bacpac" -AxDeployExtUserPwd "XxXx" -AxDbAdminPwd "XxXx" -AxRuntimeUserPwd "XxXx" -AxMrRuntimeUserPwd "XxXx" -AxRetailRuntimeUserPwd "XxXx" -AxRetailDataSyncUserPwd "XxXx" -NewDatabaseName "ImportedDatabase" -verbose

.NOTES
General notes
#>
function Import-D365BacpacOldVersion {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnly', Position = 1 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly', Position = 1 )]
        [Alias('AzureDB')]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnly', Position = 2 )]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnly', Position = 3 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly', Position = 3 )]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnly', Position = 4 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly', Position = 4 )]
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 5)]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportOnly', ValueFromPipelineByPropertyName = $true, Position = 5 )]        
        [Alias('File')]
        [string]$BacpacFile,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 6)]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportOnly', Position = 6 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly', Position = 2 )]
        [string]$NewDatabaseName,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 7)]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly' )]
        [string]$AxDeployExtUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 8)]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly' )]
        [string]$AxDbAdminPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 9)]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly' )]
        [string]$AxRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 10)]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly' )]
        [string]$AxMrRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 11)]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly' )]
        [string]$AxRetailRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 12)]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly' )]
        [string]$AxRetailDataSyncUserPwd,

        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnly' )]
        [switch]$ImportOnly,

        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateOnly' )]
        [switch]$UpdateOnly
    )

    if (!$script:IsAdminRuntime -and !($PSBoundParameters.ContainsKey("SqlPwd"))) {
        Write-Host "It seems that you ran this cmdlet non-elevated and without the -SqlPwd parameter. If you don't want to supply the -SqlPwd you must run the cmdlet elevated (Run As Administrator) or simply use the -SqlPwd parameter" -ForegroundColor Yellow
        Write-Error "Running non-elevated and without the -SqlPwd parameter. Please run elevated or supply the -SqlPwd parameter." -ErrorAction Stop
    }

    $command = $Script:SqlPackage

    if ([System.IO.File]::Exists($command) -ne $True) {
        Write-Host "The sqlpackage.exe is not present on the system. This is an important part of making the bacpac file. Please install latest SQL Server Management Studio on the machine and run the cmdlet again. `r`nVisit this link:`r`ndocs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms" -ForegroundColor Yellow
        Write-Error "The sqlpackage.exe is missing on the system." -ErrorAction Stop
    }

    $StartTime = Get-Date

    $azureSql = $false

    if ($DatabaseServer -like "*.database.windows.net" ) { $azureSql = $true  } else {$azureSql = $false}

    Write-Host 'Please make sure that SSMS is updated' -ForegroundColor Yellow

    Write-Verbose "Restoring $BacpacFile"

    if ($azureSql -eq $true -and !$UpdateOnly.IsPresent) {

        [System.Data.SqlClient.SqlCommand]$sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

        $commandText = (Get-Content "$script:ModuleRoot\internal\sql\get-azureserviceobjective.sql") -join [Environment]::NewLine

        $sqlCommand.CommandText = $commandText

        $sqlCommand.Connection.Open()

        $reader = $sqlCommand.ExecuteReader()

        if ($reader.Read() -eq $true) {

            $edition = $reader.GetString(1)
            $serviceObjective = $reader.GetString(2)

            Write-Verbose "Edition $edition"
            Write-Verbose "ServiceObjective $serviceObjective"

            $reader.close()
            
            $sqlCommand.Connection.Close()
            $sqlCommand.Dispose()

            $param = "/a:import /tsn:$DatabaseServer /tdn:$NewDatabaseName /sf:$BacpacFile /tu:$SqlUser /tp:$SqlPwd /p:CommandTimeout=1200 /p:DatabaseEdition=$edition /p:DatabaseServiceObjective=$serviceObjective"
        }
        else {
            Write-Error "Could not find service objectives." -ErrorAction stop
        }
    }
    else {
        $param = "/a:import /tsn:$DatabaseServer /tdn:$NewDatabaseName /sf:$BacpacFile /tu:$SqlUser /tp:$SqlPwd /p:CommandTimeout=1200"
    }

    if (!$UpdateOnly) {
        Start-Process -FilePath $command -ArgumentList  $param  -NoNewWindow -Wait
    }

    if (!$ImportOnly.IsPresent) {
        $sqlCommand = Get-SQLCommand $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd

        $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-instancevalue.sql") -join [Environment]::NewLine

        $sqlCommand.Connection.Open()

        $reader = $sqlCommand.ExecuteReader()

        if ($reader.read() -eq $true) {

            $tenantId = $reader.GetString(0)
            $planId = $reader.GetGuid(1)
            $planCapability = $reader.GetString(2)

            $reader.close()
        }
        else {
            Write-Error "" -ErrorAction Stop
        }

        if ($azureSql) {
            $commandText = (Get-Content "$script:ModuleRoot\internal\sql\set-bacpacvaluesazure.sql") -join [Environment]::NewLine
        }
        else {
            $commandText = (Get-Content "$script:ModuleRoot\internal\sql\set-bacpacvaluessql.sql") -join [Environment]::NewLine

        }

        $commandText = $commandText.Replace('@axdeployextuser', $AxDeployExtUserPwd)

        $commandText = $commandText.Replace('@axdbadmin', $AxDbAdminPwd)

        $commandText = $commandText.Replace('@axruntimeuser', $AxRuntimeUserPwd)

        $commandText = $commandText.Replace('@axmrruntimeuser', $AxMrRuntimeUserPwd)

        $commandText = $commandText.Replace('@axretailruntimeuser', $AxRetailRuntimeUserPwd)

        $commandText = $commandText.Replace('@axretaildatasyncuser', $AxRetailDataSyncUserPwd)

        $sqlCommand.CommandText = $commandText

        $null = $sqlCommand.Parameters.Add("@TenantId", $tenantId)
        $null = $sqlCommand.Parameters.Add("@PlanId", $planId)
        $null = $sqlCommand.Parameters.Add("@PlanCapability ", $planCapability)

        write-verbose $sqlCommand.CommandText

        $sqlCommand.ExecuteNonQuery()
        
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }

    $EndTime = Get-Date

    $TimeSpan = New-TimeSpan -End $EndTime -Start $StartTime

        Write-Host "Time Taken" -ForegroundColor Green
        Write-Host "$TimeSpan" -ForegroundColor Green
}
