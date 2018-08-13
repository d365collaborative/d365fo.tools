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

This will instruct the cmdlet that the import will be working against a SQL Server instance.
It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".

.EXAMPLE
Import-D365BacpacOldVersion -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd "XyzXyz" -BacpacFile "C:\temp\uat.bacpac" -AxDeployExtUserPwd "XxXx" -AxDbAdminPwd "XxXx" -AxRuntimeUserPwd "XxXx" -AxMrRuntimeUserPwd "XxXx" -AxRetailRuntimeUserPwd "XxXx" -AxRetailDataSyncUserPwd "XxXx" -NewDatabaseName "ImportedDatabase"

This will instruct the cmdlet that the import will be working against an Azure DB instance.
It requires all relevant passwords from LCS for all the builtin user accounts used in a Tier 2
environment.
It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".

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
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 4)]
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

    $UseTrustedConnection = $Script:CanUseTrustedConnection

    if ($ImportModeTier2::IsPresent) {
        $UseTrustedConnection = $false
    }
    elseif (($PSBoundParameters.ContainsKey("SqlUser")) -or ($PSBoundParameters.ContainsKey("SqlPwd"))) {
        $UseTrustedConnection = $false
    }
    Write-PSFMessage -Level Verbose -Message "Trusted Connection logic executed" -Target $UseTrustedConnection

    $command = $Script:SqlPackage

    if ([System.IO.File]::Exists($command) -ne $True) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>sqlpackage.exe</c> file on the machine. Please ensure that the latest <c='em'>SQL Server Management Studio</c> is installed using the <c='em'>default location</c> and run the cmdlet again. You can visit this link to obtain the latest SSMS: <c=`"green`">http://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms</c>"
        Stop-PSFFunction -Message "The sqlpackage.exe is missing on the system."
        return
    }

    $StartTime = Get-Date

    [System.Collections.ArrayList]$Params = New-Object -TypeName "System.Collections.ArrayList"

    Write-PSFMessage -Level Verbose "Testing if we are working against a Tier2 / Azure DB" 
    if ($ImportModeTier2::IsPresent) {
        Write-PSFMessage -Level Verbose "Start collecting the current Azure DB instance settings" 

        $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd $UseTrustedConnection

        $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\get-azureserviceobjective.sql") -join [Environment]::NewLine

        $sqlCommand.CommandText = $commandText

        $sqlCommand.Connection.Open()

        $reader = $sqlCommand.ExecuteReader()

        if ($reader.Read() -eq $true) {

            $edition = $reader.GetString(1)
            $serviceObjective = $reader.GetString(2)

            Write-PSFMessage -Level Verbose -Message "Azure DB Edition: $edition"
            Write-PSFMessage -Level Verbose -Message "Azure DB ServiceObjective: $serviceObjective"

            $reader.close()
            
            $sqlCommand.Connection.Close()
            $sqlCommand.Dispose()

            Write-PSFMessage -Level Verbose "Building the parameter string for importing the bacpac into the Azure DB instance with a new name and current settings" 
            $null = $Params.Add("/Action:import")
            $null = $Params.Add("/TargetServerName:$DatabaseServer")
            $null = $Params.Add("/TargetDatabaseName:$NewDatabaseName")
            $null = $Params.Add("/SourceFile:$BacpacFile")
            $null = $Params.Add("/Properties:CommandTimeout=1200")
            $null = $Params.Add("/Properties:DatabaseEdition=$edition")
            $null = $Params.Add("/Properties:DatabaseServiceObjective=$serviceObjective")
            $null = $Params.Add("/TargetUser:$SqlUser")
            $null = $Params.Add("/TargetPassword:$SqlPwd")

            #            $param = "/a:import /tsn:$DatabaseServer /tdn:$NewDatabaseName /sf:$BacpacFile /tu:$SqlUser /tp:$SqlPwd /p:CommandTimeout=1200 /p:DatabaseEdition=$edition /p:DatabaseServiceObjective=$serviceObjective"
        }
        else {
            Write-PSFMessage -Level Host -Message "The query to detect <c='em'>edition</c> and <c='em'>service objectives</c> from the Azure DB instance <c='em'>failed</c>."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }
    else {
        Write-PSFMessage -Level Verbose "Building the parameter string for importing the bacpac into the SQL Server instance with a new name and current settings" 
        $null = $Params.Add("/Action:import")
        $null = $Params.Add("/TargetServerName:$DatabaseServer")
        $null = $Params.Add("/TargetDatabaseName:$NewDatabaseName")
        $null = $Params.Add("/SourceFile:$BacpacFile")
        $null = $Params.Add("/Properties:CommandTimeout=1200")
        #$null = $Params.Add("/Diagnostics:True")
        
        if (!$UseTrustedConnection) {
            $null = $Params.Add("/TargetUser:$SqlUser")
            $null = $Params.Add("/TargetPassword:$SqlPwd")
        }    
    }

    Write-PSFMessage -Level Verbose "Start importing the bacpac with a new database name and current settings" 
    Start-Process -FilePath $command -ArgumentList ($Params -join " ") -NoNewWindow -Wait
    Write-PSFMessage -Level Verbose "Importing completed" 

    if (!$ImportOnly.IsPresent) {
        Write-PSFMessage -Level Verbose -Message "Start working on the configuring the new database"
        $sqlCommand = Get-SQLCommand $DatabaseServer $NewDatabaseName $SqlUser $SqlPwd $UseTrustedConnection

        $sqlCommand.CommandText = (Get-Content "$script:PSModuleRoot\internal\sql\get-instancevalue.sql") -join [Environment]::NewLine

        try {
            $sqlCommand.Connection.Open()

            $reader = $sqlCommand.ExecuteReader()

            if ($reader.read() -eq $true) {

                $tenantId = $reader.GetString(0)
                $planId = $reader.GetGuid(1)
                $planCapability = $reader.GetString(2)

                $reader.close()
            }
            else {
                Write-PSFMessage -Level Host -Message "The query to detect <c='em'>details</c> from the SQL Server <c='em'>failed</c>."
                Stop-PSFFunction -Message "Stopping because of missing parameters"
                return
            }
        }
        catch {
            Write-PSFMessage -Level Verbose -Message "Execution of SQL failed." -Exception $_.Exception 
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database."            
            Stop-PSFFunction -Message "Stopping because of errors while working against the database."
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

    Write-PSFMessage -Level Verbose -Message "Total time for the import operation was $TimeSpan" -Target $TimeSpan
}
