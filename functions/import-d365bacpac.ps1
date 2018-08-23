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
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportOnlyTier2', Position = 0)]
        [switch]$ImportModeTier2,

        [Parameter(Mandatory = $false, Position = 1 )]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 3)]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportOnlyTier2', Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 4)]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportOnlyTier2', Position = 4)]
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 5 )]
        [Alias('File')]
        [string]$BacpacFile,

        [Parameter(Mandatory = $true, Position = 6 )]
        [string]$NewDatabaseName,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 7)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 7)]
        [string]$AxDeployExtUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 8)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 8)]
        [string]$AxDbAdminPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 9)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 9)]
        [string]$AxRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 10)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 10)]
        [string]$AxMrRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 11)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 11)]
        [string]$AxRetailRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', Position = 12)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 12)]
        [string]$AxRetailDataSyncUserPwd,
        
        [Parameter(Mandatory = $false, Position = 13 )]
        [string]$CustomSqlFile,

        [Parameter(Mandatory = $false, ParameterSetName = 'ImportTier1')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportOnlyTier2')]
        [switch]$ImportOnly   
    )

    Invoke-TimeSignal -Start
    
    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    if (!(Test-Path $BacpacFile -PathType Leaf)) {    
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>bacpac</c> file on the machine. Please make sure that the path exists and you have enough permissions."
        Stop-PSFFunction -Message "Unable to locate the specified bacpac file."
        return
    }

    if ($PSBoundParameters.ContainsKey("CustomSqlFile")) {
        if ((Test-Path $CustomSqlFile -PathType Leaf) -eq $false) {
            Write-PSFMessage -Level Host -Message "You used the <c='em'>CustomSqlFile</c> parameter, but the cmdlet is unable to locate the file on the machine. Please make sure that the path exists and you have enough permissions."
            Stop-PSFFunction -Message "The CustomSqlFile path was not located."
            return
        }
        else {
            $ExecuteCustomSQL = $true
        }
    }

    $BaseParams = @{
        DatabaseServer = $DatabaseServer
        DatabaseName   = $DatabaseName
        SqlUser        = $SqlUser
        SqlPwd         = $SqlPwd        
    }

    $ImportParams = @{
        Action   = "import"
        FilePath = $BacpacFile        
    }

    Write-PSFMessage -Level Verbose "Testing if we are working against a Tier2 / Azure DB" 
    if ($ImportModeTier2.IsPresent) {
        Write-PSFMessage -Level Verbose "Start collecting the current Azure DB instance settings" 

        $Objectives = Get-AzureServiceObjectives @BaseParams

        if ($null -eq $Objectives) { return }

        $Properties = @("DatabaseEdition=$($Objectives.DatabaseEdition)",
            "DatabaseServiceObjective=$($Objectives.DatabaseServiceObjective)"
        )

        $ImportParams.Properties = $Properties
    }
    
    $Params = Get-DeepClone $BaseParams
    $Params.DatabaseName = $NewDatabaseName
    
    Write-PSFMessage -Level Verbose "Start importing the bacpac with a new database name and current settings" 
    $res = Invoke-SqlPackage @Params @ImportParams -TrustedConnection $UseTrustedConnection

    if (!$res) {return}
    
    Write-PSFMessage -Level Verbose "Importing completed" 

    if (!$ImportOnly.IsPresent) {
        Write-PSFMessage -Level Verbose -Message "Start working on the configuring the new database"
        
        $InstanceValues = Get-InstanceValues @Params -TrustedConnection $UseTrustedConnection

        if ($null -eq $InstanceValues) { return }

        if ($ImportModeTier2.IsPresent) {
            Write-PSFMessage -Level Verbose "Building sql statement to update the imported Azure database" 

            $AzureParams = @{AxDeployExtUserPwd = $AxDeployExtUserPwd; AxDbAdminPwd = $AxDbAdminPwd; AxRuntimeUserPwd = $AxRuntimeUserPwd; AxMrRuntimeUserPwd = $AxMrRuntimeUserPwd; AxRetailRuntimeUserPwd = $AxRetailRuntimeUserPwd; AxRetailDataSyncUserPwd = $AxRetailDataSyncUserPwd}
            $res = Set-AzureBacpacValues @Params @AzureParams @InstanceValues

            if (!$res) {return}
        }
        else {
            Write-PSFMessage -Level Verbose "Building sql statement to update the imported SQL database" 

            $res = Set-SqlBacpacValues @Params -TrustedConnection $UseTrustedConnection @InstanceValues
            
            if (!$res) {return}
        }

        if ($ExecuteCustomSQL) {
            Write-PSFMessage -Level Verbose -Message "Invoking the Execution of custom SQL script"
            $res = Invoke-CustomSqlScript @Params -FilePath $CustomSqlFile -TrustedConnection $UseTrustedConnection

            if (!$res) {return}
        }
    }

    Invoke-TimeSignal -End
}
