function Get-InstanceValues {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DatabaseServer,

        [Parameter(Mandatory = $true)]
        [string] $DatabaseName, 

        [Parameter(Mandatory = $false)]
        [string] $SqlUser, 

        [Parameter(Mandatory = $false)]
        [string] $SqlPwd,

        [Parameter(Mandatory = $false)]
        [bool] $TrustedConnection
    )
        
    $sqlCommand = Get-SQLCommand @PsBoundParameters

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\get-instancevalue.sql") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText

    try {
        $sqlCommand.Connection.Open()

        Write-PSFMessage -Level Verbose "Execute the statement against the DB instance" -Target $sqlCommand
        $reader = $sqlCommand.ExecuteReader()
        
        if ($reader.Read() -eq $true) {
            Write-PSFMessage -Level Verbose "Extracting details from the result retrieved from the DB instance"

            $tenantId = $reader.GetString(0)
            $planId = $reader.GetGuid(1)
            $planCapability = $reader.GetString(2)

            @{
                TenantId       = $tenantId
                PlanId         = $planId
                PlanCapability = $planCapability
            }
        }
        else {
            Write-PSFMessage -Level Host -Message "The query to detect <c='em'>TenantId</c>, <c='em'>PlanId</c> and <c='em'>PlanCapability</c> from the database <c='em'>failed</c>."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $reader.close()
            
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }
}