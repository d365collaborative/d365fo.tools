
<#
    .SYNOPSIS
        Sets the environment into maintenance mode
        
    .DESCRIPTION
        Sets the Dynamics 365 environment into maintenance mode to enable the user to update the license configuration
        
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
        
    .EXAMPLE
        PS C:\> Disable-D365SqlChangeTracking
        
        This will disable the Change Tracking on the Sql Server.
        
    .NOTES
        Tags: MaintenanceMode, Maintenance, License, Configuration, Servicing
        
        Author: Mötz Jensen (@splaxi)
#>
function Disable-D365SqlChangeTracking {
    [CmdletBinding()]
    param (
        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters
    
    $Params = @{DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd; TrustedConnection = $UseTrustedConnection;
    }

    $sqlCommand = Get-SQLCommand @Params

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\disable-changetracking.sql") -join [Environment]::NewLine
    $commandText = $commandText.Replace('@DATABASENAME', $DatabaseName)

    $sqlCommand.CommandText = $commandText

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
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

    Invoke-TimeSignal -End

}