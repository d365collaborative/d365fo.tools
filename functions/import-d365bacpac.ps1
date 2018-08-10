<#
.SYNOPSIS
Import a bacpac file

.DESCRIPTION
Import a bacpac file to either a Tier1 or Tier2 environment

.PARAMETER ImportModeTier1
Switch to instruct the cmdlet that it will import into a Tier1 environment

The cmdlet will expect to work against a SQL Server instance

.PARAMETER ImportModeTier2
Switch to instruct the cmdlet that it will import into a Tier2 environment

The cmdlet will expect to work against an Azure DB instance

.PARAMETER DatabaseServer
The name of the database server

If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).

If Azure use the full address to the database server, e.g. server.database.windows.net

.PARAMETER DatabaseName
The name of the database

.PARAMETER SqlUser
The login name for the SQL Server instance

.PARAMETER SqlPwd
The password for the SQL Server user

.PARAMETER BacpacFile
Path to the bacpac file you want to import into the database server

.PARAMETER NewDatabaseName
Name of the new database that will be created while importing the bacpac file

This will create a new database on the database server and import the content of the bacpac into

.PARAMETER AxDeployExtUserPwd
Parameter description

.PARAMETER AxDbAdminPwd
Parameter description

.PARAMETER AxRuntimeUserPwd
Parameter description

.PARAMETER AxMrRuntimeUserPwd
Parameter description

.PARAMETER AxRetailRuntimeUserPwd
Parameter description

.PARAMETER AxRetailDataSyncUserPwd
Parameter description

.PARAMETER ImportOnly
Switch to instruct the cmdlet to only import the bacpac into the new database

The cmdlet will create a new database and import the content of the bacpac file into this

Nothing else will be executed

.EXAMPLE
Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase"

.NOTES
General notes
#>#
function Import-D365Bacpac {
    [CmdletBinding(DefaultParameterSetName = 'ImportTier1')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier1', Position = 0)]
        [switch]$ImportModeTier1,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 0)]
        [switch]$ImportModeTier2,

        [Parameter(Mandatory = $false, Position = 1 )]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3 )]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4 )]
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, Position = 5 )]
        [string]$BacpacFile,

        [Parameter(Mandatory = $true, Position = 6 )]
        [string]$NewDatabaseName,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 7)]
        [string]$AxDeployExtUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 8)]
        [string]$AxDbAdminPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 9)]
        [string]$AxRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 10)]
        [string]$AxMrRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 11)]
        [string]$AxRetailRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 12)]
        [string]$AxRetailDataSyncUserPwd,
        
        [switch]$ImportOnly   
        

    )
    
    Write-PSFMessage -Level Verbose -Message "Testing if run on LocalHostedTier1 and console isn't elevated"
    if ($Script:EnvironmentType -eq [EnvironmentType]::LocalHostedTier1 -and !$script:IsAdminRuntime){
        Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet <c=`"red`">non-elevated</c> and on a <c=`"red`">local VM / local vhd</c>. Being on a local VM / local VHD requires you to run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`""
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }
    elseif (!$script:IsAdminRuntime -and $Script:UserIsAdmin -and $Script:EnvironmentType -ne [EnvironmentType]::LocalHostedTier1) {
        Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet <c=`"red`">non-elevated</c> and as an <c=`"red`">administrator</c>. You should either logon as a non-admin user account on this machine or run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`" or simply logon as another user"
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    $command = $Script:SqlPackage

    if ([System.IO.File]::Exists($command) -ne $True) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c=`"red`">sqlpackage.exe</c> file on the machine. Please ensure that the latest <c=`"red`">SQL Server Management Studio</c> is installed using the <c=`"red`">default location</c> and run the cmdlet again. You can visit this link to obtain the latest SSMS: <c=`"green`">http://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms</c>"
        Stop-PSFFunction -Message "The sqlpackage.exe is missing on the system."
        return
    }

    $StartTime = Get-Date

    Write-PSFMessage -Level Verbose "Testing if we are working against a Tier2 / Azure DB" 
    if ($ImportModeTier2::IsPresent) {
        Write-PSFMessage -Level Verbose "Start collecting the current Azure DB instance settings" 

        [System.Data.SqlClient.SqlCommand]$sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

        $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\get-azureserviceobjective.sql") -join [Environment]::NewLine

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

            Write-PSFMessage -Level Verbose "Building the parameter string for importing the bacpac into the Azure DB instance with a new name and current settings" 
            $param = "/a:import /tsn:$DatabaseServer /tdn:$NewDatabaseName /sf:$BacpacFile /tu:$SqlUser /tp:$SqlPwd /p:CommandTimeout=1200 /p:DatabaseEdition=$edition /p:DatabaseServiceObjective=$serviceObjective"
        }
        else {
            Write-PSFMessage -Level Host -Message "Could not find service objectives from the Azure DB instance."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }
    else {
        Write-PSFMessage -Level Verbose "Building the parameter string for importing the bacpac into the SQL Server instance with a new name and current settings" 
        $param = "/a:import /tsn:$DatabaseServer /tdn:$NewDatabaseName /sf:$BacpacFile /tu:$SqlUser /tp:$SqlPwd /p:CommandTimeout=1200"
    }

    Write-PSFMessage -Level Verbose "Start importing the bacpac with a new database name and current settings" 
    Start-Process -FilePath $command -ArgumentList  $param  -NoNewWindow -Wait

    if (!$ImportOnly.IsPresent) {
        $sqlCommand = Get-SQLCommand $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd

        $sqlCommand.CommandText = (Get-Content "$script:PSModuleRoot\internal\sql\get-instancevalue.sql") -join [Environment]::NewLine

        $sqlCommand.Connection.Open()

        $reader = $sqlCommand.ExecuteReader()

        if ($reader.read() -eq $true) {

            $tenantId = $reader.GetString(0)
            $planId = $reader.GetGuid(1)
            $planCapability = $reader.GetString(2)

            $reader.close()
        }
        else {
            Write-PSFMessage -Level Host -Message "Error while fetching details from the database"
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }

        Write-PSFMessage -Level Verbose "Building sql statement to update the imported database" 
        if ($ImportModeTier2::IsPresent) {
            $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\set-bacpacvaluesazure.sql") -join [Environment]::NewLine

            $commandText = $commandText.Replace('@axdeployextuser', $AxDeployExtUserPwd)
            $commandText = $commandText.Replace('@axdbadmin', $AxDbAdminPwd)
            $commandText = $commandText.Replace('@axruntimeuser', $AxRuntimeUserPwd)
            $commandText = $commandText.Replace('@axmrruntimeuser', $AxMrRuntimeUserPwd)
            $commandText = $commandText.Replace('@axretailruntimeuser', $AxRetailRuntimeUserPwd)
            $commandText = $commandText.Replace('@axretaildatasyncuser', $AxRetailDataSyncUserPwd)
        }
        else {
            $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\set-bacpacvaluessql.sql") -join [Environment]::NewLine
            $commandText = $commandText.Replace('@DATABASENAME', $NewDatabaseName)
        }

        $sqlCommand.CommandText = $commandText

        $null = $sqlCommand.Parameters.Add("@TenantId", $tenantId)
        $null = $sqlCommand.Parameters.Add("@PlanId", $planId)
        $null = $sqlCommand.Parameters.Add("@PlanCapability ", $planCapability)
                
        Write-PSFMessage -Level Verbose "Execution sql statement against database" -Target $sqlCommand.CommandText
        $sqlCommand.ExecuteNonQuery()
        
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }

    $EndTime = Get-Date

    $TimeSpan = New-TimeSpan -End $EndTime -Start $StartTime

    Write-Host "Time Taken" -ForegroundColor Green
    Write-Host "$TimeSpan" -ForegroundColor Green
}
