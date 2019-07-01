
<#
    .SYNOPSIS
        Get the maintenance mode status of the environment
        
    .DESCRIPTION
        Get the maintenance mode status of the Dynamics 365 environment to make sure that things are in the correct state
        
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
        PS C:\> Get-D365MaintenanceMode
        
        This will get the current state of the maintenance mode of the environment
        
    .NOTES
        Tags: MaintenanceMode, Maintenance, License, Configuration, Servicing
        
        Author: Mötz Jensen (@splaxi)
        
    .LINK
        Enable-D365MaintenanceMode
        
    .LINK
        Disable-D365MaintenanceMode
#>
function Get-D365MaintenanceMode {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 5 )]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 6 )]
        [string] $SqlPwd = $Script:DatabaseUserPassword
    )

        Write-PSFMessage -Level Verbose -Message "Getting Maintenance Mode using SQL scripts."

        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $sqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-maintenancemode.sql") -join [Environment]::NewLine

    try {
        $sqlCommand.Connection.Open()
    
        $reader = $sqlCommand.ExecuteReader()

        while ($reader.Read() -eq $true) {
            [PSCustomObject]@{
                MaintenanceModeEnabled          = [bool][int]"$($reader.GetString($($reader.GetOrdinal("VALUE"))))"
            }
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $reader.close()

        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()
    }
}