
<#
    .SYNOPSIS
        Get the Azure Database instance values
        
    .DESCRIPTION
        Extract the PlanId, TenantId and PlanCapability from the Azure Database instance
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user.
        
    .PARAMETER TrustedConnection
        Should the connection use a Trusted Connection or not
        
    .EXAMPLE
        PS C:\> Get-InstanceValues -DatabaseServer SQLServer -DatabaseName AXDB -SqlUser "SqlAdmin" -SqlPwd "Pass@word1"
        
        This will extract the PlanId, TenantId and PlanCapability from the AXDB on the SQLServer, using the "SqlAdmin" credentials to do so.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-InstanceValues {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType('System.Collections.Hashtable')]
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
        [boolean] $TrustedConnection
    )
        
    $sqlCommand = Get-SqlCommand @PsBoundParameters

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\get-instancevalues.sql") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

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