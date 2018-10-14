function Set-AzureBacpacValues {
    [CmdletBinding()]
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
        [string]$AxDeployExtUserPwd,

        [Parameter(Mandatory = $true)]
        [string]$AxDbAdminPwd,

        [Parameter(Mandatory = $true)]
        [string]$AxRuntimeUserPwd,

        [Parameter(Mandatory = $true)]
        [string]$AxMrRuntimeUserPwd,

        [Parameter(Mandatory = $true)]
        [string]$AxRetailRuntimeUserPwd,

        [Parameter(Mandatory = $true)]
        [string]$AxRetailDataSyncUserPwd,

        [Parameter(Mandatory = $true)]
        [string]$TenantId,

        [Parameter(Mandatory = $true)]
        [string]$PlanId,
        
        [Parameter(Mandatory = $true)]
        [string]$PlanCapability
    )
        
    $sqlCommand = Get-SqlCommand -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName -SqlUser $SqlUser -SqlPwd $SqlPwd -TrustedConnection $false

    $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\set-bacpacvaluesazure.sql") -join [Environment]::NewLine

    $commandText = $commandText.Replace('@axdeployextuser', $AxDeployExtUserPwd)
    $commandText = $commandText.Replace('@axdbadmin', $AxDbAdminPwd)
    $commandText = $commandText.Replace('@axruntimeuser', $AxRuntimeUserPwd)
    $commandText = $commandText.Replace('@axmrruntimeuser', $AxMrRuntimeUserPwd)
    $commandText = $commandText.Replace('@axretailruntimeuser', $AxRetailRuntimeUserPwd)
    $commandText = $commandText.Replace('@axretaildatasyncuser', $AxRetailDataSyncUserPwd)

    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@TenantId", $TenantId)
    $null = $sqlCommand.Parameters.Add("@PlanId", $PlanId)
    $null = $sqlCommand.Parameters.Add("@PlanCapability ", $PlanCapability)

    try {
        Write-PSFMessage -Level Verbose "Execution sql statement against database" -Target $sqlCommand.CommandText
        $sqlCommand.Connection.Open()
        $null = $sqlCommand.ExecuteNonQuery()     
        
        $true
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()    
        }

        $sqlCommand.Dispose()
    }
}