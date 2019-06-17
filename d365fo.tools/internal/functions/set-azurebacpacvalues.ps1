
<#
    .SYNOPSIS
        Change the different Azure SQL Database details
        
    .DESCRIPTION
        When preparing an Azure SQL Database to be the new database for an Tier 2+ environment you need to set different details
        
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
        
    .PARAMETER AxDeployExtUserPwd
        Password obtained from LCS
        
    .PARAMETER AxDbAdminPwd
        Password obtained from LCS
        
    .PARAMETER AxRuntimeUserPwd
        Password obtained from LCS
        
    .PARAMETER AxMrRuntimeUserPwd
        Password obtained from LCS
        
    .PARAMETER AxRetailRuntimeUserPwd
        Password obtained from LCS
        
    .PARAMETER AxRetailDataSyncUserPwd
        Password obtained from LCS
        
    .PARAMETER AxDbReadonlyUserPwd
        Password obtained from LCS
        
    .PARAMETER TenantId
        The ID of tenant that the Azure SQL Database instance is going to be run under
        
    .PARAMETER PlanId
        The ID of the type of plan that the Azure SQL Database is going to be using
        
    .PARAMETER PlanCapability
        The capabilities that the Azure SQL Database instance will be running with
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Set-AzureBacpacValues -DatabaseServer dbserver1.database.windows.net -DatabaseName Import -SqlUser User123 -SqlPwd "Password123" -AxDeployExtUserPwd "Password123" -AxDbAdminPwd "Password123" -AxRuntimeUserPwd "Password123" -AxMrRuntimeUserPwd "Password123" -AxRetailRuntimeUserPwd "Password123" -AxRetailDataSyncUserPwd "Password123" -AxDbReadonlyUserPwd "Password123" -TenantId "TenantIdFromAzure" -PlanId "PlanIdFromAzure" -PlanCapability "Capabilities"
        
        This will set all the needed details inside the "Import" database that is located in the "dbserver1.database.windows.net" Azure SQL Database instance.
        All service accounts and their passwords will be updated accordingly.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Set-AzureBacpacValues {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DatabaseServer,

        [Parameter(Mandatory = $true)]
        [string] $DatabaseName,

        [Parameter(Mandatory = $true)]
        [string] $SqlUser,

        [Parameter(Mandatory = $true)]
        [string] $SqlPwd,

        [Parameter(Mandatory = $true)]
        [string] $AxDeployExtUserPwd,

        [Parameter(Mandatory = $true)]
        [string] $AxDbAdminPwd,

        [Parameter(Mandatory = $true)]
        [string] $AxRuntimeUserPwd,

        [Parameter(Mandatory = $true)]
        [string] $AxMrRuntimeUserPwd,

        [Parameter(Mandatory = $true)]
        [string] $AxRetailRuntimeUserPwd,

        [Parameter(Mandatory = $true)]
        [string] $AxRetailDataSyncUserPwd,

        [Parameter(Mandatory = $true)]
        [string] $AxDbReadonlyUserPwd,

        [Parameter(Mandatory = $true)]
        [string] $TenantId,
        
        [Parameter(Mandatory = $true)]
        [string] $PlanId,
        
        [Parameter(Mandatory = $true)]
        [string] $PlanCapability,

        [switch] $EnableException
    )
        
    $sqlCommand = Get-SQLCommand -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName -SqlUser $SqlUser -SqlPwd $SqlPwd -TrustedConnection $false

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\set-bacpacvaluesazure.sql") -join [Environment]::NewLine

    $commandText = $commandText.Replace('@axdeployextuser', $AxDeployExtUserPwd)
    $commandText = $commandText.Replace('@axdbadmin', $AxDbAdminPwd)
    $commandText = $commandText.Replace('@axruntimeuser', $AxRuntimeUserPwd)
    $commandText = $commandText.Replace('@axmrruntimeuser', $AxMrRuntimeUserPwd)
    $commandText = $commandText.Replace('@axretailruntimeuser', $AxRetailRuntimeUserPwd)
    $commandText = $commandText.Replace('@axretaildatasyncuser', $AxRetailDataSyncUserPwd)
    $commandText = $commandText.Replace('@axdbreadonlyuser', $AxDbReadonlyUserPwd)

    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@TenantId", $TenantId)
    $null = $sqlCommand.Parameters.Add("@PlanId", $PlanId)
    $null = $sqlCommand.Parameters.Add("@PlanCapability ", $PlanCapability)

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
        
        $true
    }
    catch {
        $messageString = "Something went wrong while working against the database."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()
    }
}