
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
        Password that is obtained from LCS
        
    .PARAMETER AxDbAdminPwd
        Password that is obtained from LCS
        
    .PARAMETER AxRuntimeUserPwd
        Password that is obtained from LCS
        
    .PARAMETER AxMrRuntimeUserPwd
        Password that is obtained from LCS
        
    .PARAMETER AxRetailRuntimeUserPwd
        Password that is obtained from LCS
        
    .PARAMETER AxRetailDataSyncUserPwd
        Password that is obtained from LCS
        
    .PARAMETER AxDbReadonlyUserPwd
        Password that is obtained from LCS
        
    .PARAMETER CustomSqlFile
        Parameter description
        
    .PARAMETER ImportOnly
        Switch to instruct the cmdlet to only import the bacpac into the new database
        
        The cmdlet will create a new database and import the content of the bacpac file into this
        
        Nothing else will be executed
        
    .EXAMPLE
        PS C:\> Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\temp\uat.bacpac" -NewDatabaseName "ImportedDatabase"
        PS C:\> Switch-D365ActiveDatabase -NewDatabaseName "ImportedDatabase"
        
        This will instruct the cmdlet that the import will be working against a SQL Server instance.
        It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
        The next thing to do is to switch the active database out with the new one you just imported.
        "ImportedDatabase" will be switched in as the active database, while the old one will be named "AXDB_original".
        
    .EXAMPLE
        PS C:\> Import-D365Bacpac -ImportModeTier2 -SqlUser "sqladmin" -SqlPwd "XyzXyz" -BacpacFile "C:\temp\uat.bacpac" -AxDeployExtUserPwd "XxXx" -AxDbAdminPwd "XxXx" -AxRuntimeUserPwd "XxXx" -AxMrRuntimeUserPwd "XxXx" -AxRetailRuntimeUserPwd "XxXx" -AxRetailDataSyncUserPwd "XxXx" -AxDbReadonlyUserPwd "XxXx" -NewDatabaseName "ImportedDatabase"
        PS C:\> Switch-D365ActiveDatabase -NewDatabaseName "ImportedDatabase" -SqlUser "sqladmin" -SqlPwd "XyzXyz"
        
        This will instruct the cmdlet that the import will be working against an Azure DB instance.
        It requires all relevant passwords from LCS for all the builtin user accounts used in a Tier 2 environment.
        It will import the "C:\temp\uat.bacpac" file into a new database named "ImportedDatabase".
        The next thing to do is to switch the active database out with the new one you just imported.
        "ImportedDatabase" will be switched in as the active database, while the old one will be named "AXDB_original".
        
    .NOTES
        Tags: Database, Bacpac, Tier1, Tier2, Golden Config, Config, Configuration
        
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
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
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', ValueFromPipelineByPropertyName = $true, Position = 3)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportTier1', Position = 3)]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportOnlyTier2', ValueFromPipelineByPropertyName = $true, Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', ValueFromPipelineByPropertyName = $true, Position = 4)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportTier1', Position = 4)]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportOnlyTier2', ValueFromPipelineByPropertyName = $true, Position = 4)]
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 5 )]
        [Alias('File')]
        [string]$BacpacFile,

        [Parameter(Mandatory = $true, Position = 6 )]
        [string]$NewDatabaseName,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', ValueFromPipelineByPropertyName = $true, Position = 7)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 7)]
        [string]$AxDeployExtUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', ValueFromPipelineByPropertyName = $true, Position = 8)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 8)]
        [string]$AxDbAdminPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', ValueFromPipelineByPropertyName = $true, Position = 9)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 9)]
        [string]$AxRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', ValueFromPipelineByPropertyName = $true, Position = 10)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 10)]
        [string]$AxMrRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', ValueFromPipelineByPropertyName = $true, Position = 11)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 11)]
        [string]$AxRetailRuntimeUserPwd,

        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', ValueFromPipelineByPropertyName = $true, Position = 12)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 12)]
        [string]$AxRetailDataSyncUserPwd,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportTier2', ValueFromPipelineByPropertyName = $true, Position = 13)]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportOnlyTier2', Position = 13)]
        [string]$AxDbReadonlyUserPwd,
        
        [Parameter(Mandatory = $false, Position = 14 )]
        [string]$CustomSqlFile,

        [Parameter(Mandatory = $false, ParameterSetName = 'ImportTier1')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportOnlyTier2')]
        [switch]$ImportOnly
    )

    if (-not (Test-PathExists -Path $BacpacFile -Type Leaf)) {
        return
    }

    if ($PSBoundParameters.ContainsKey("CustomSqlFile")) {
        if (-not (Test-PathExists -Path $CustomSqlFile -Type Leaf)) {
            return
        }
        else {
            $ExecuteCustomSQL = $true
        }
    }

    Invoke-TimeSignal -Start
    
    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

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
    if ($ImportModeTier2) {
        Write-PSFMessage -Level Verbose "Start collecting the current Azure DB instance settings"

        $Objectives = Get-AzureServiceObjective @BaseParams

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

    if (-not ($res)) {return}
    
    Write-PSFMessage -Level Verbose "Importing completed"

    if (-not ($ImportOnly)) {
        Write-PSFMessage -Level Verbose -Message "Start working on the configuring the new database"

        if ($ImportModeTier2) {
            Write-PSFMessage -Level Verbose "Building sql statement to update the imported Azure database"

            $InstanceValues = Get-InstanceValues @BaseParams -TrustedConnection $UseTrustedConnection

            if ($null -eq $InstanceValues) { return }

            $AzureParams = @{
                AxDeployExtUserPwd = $AxDeployExtUserPwd; AxDbAdminPwd = $AxDbAdminPwd;
                AxRuntimeUserPwd = $AxRuntimeUserPwd; AxMrRuntimeUserPwd = $AxMrRuntimeUserPwd;
                AxRetailRuntimeUserPwd = $AxRetailRuntimeUserPwd; AxRetailDataSyncUserPwd = $AxRetailDataSyncUserPwd;
                AxDbReadonlyUserPwd = $AxDbReadonlyUserPwd;
            }

            $res = Set-AzureBacpacValues @Params @AzureParams @InstanceValues

            if (-not ($res)) {return}
        }
        else {
            Write-PSFMessage -Level Verbose "Building sql statement to update the imported SQL database"

            $res = Set-SqlBacpacValues @Params -TrustedConnection $UseTrustedConnection
            
            if (-not ($res)) {return}
        }

        if ($ExecuteCustomSQL) {
            Write-PSFMessage -Level Verbose -Message "Invoking the Execution of custom SQL script"
            $res = Invoke-D365SqlScript @Params -FilePath $CustomSqlFile -TrustedConnection $UseTrustedConnection

            if (-not ($res)) {return}
        }
    }

    Invoke-TimeSignal -End
}