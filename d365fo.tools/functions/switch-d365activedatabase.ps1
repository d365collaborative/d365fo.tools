
<#
    .SYNOPSIS
        Switches the 2 databases. The Old wil be renamed _original
        
    .DESCRIPTION
        Switches the 2 databases. The Old wil be renamed _original
        
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
        
    .PARAMETER NewDatabaseName
        The database that takes the DatabaseName's place
        
    .EXAMPLE
        PS C:\> Switch-D365ActiveDatabase -NewDatabaseName "GoldenConfig"
        
        This will switch the default database AXDB out and put "GoldenConfig" in its place instead.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Switch-D365ActiveDatabase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$SqlPwd = $Script:DatabaseUserPassword,
        
        [Parameter(Mandatory = $true, Position = 5)]
        [string]$NewDatabaseName
    )

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $NewDatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    $SqlCommand.CommandText = "SELECT COUNT(1) FROM dbo.USERINFO WHERE ID = 'Admin'"

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()
        $null = $sqlCommand.ExecuteScalar()
    }
    catch {
        Write-PSFMessage -Level Host -Message "It seems that the new database either doesn't exists, isn't a valid AxDB database or your don't have enough permissions." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }
    }
    
    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = "Master";
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    if($DatabaseServer -like "*database.windows.net") {
        $commandText = (Get-Content "$script:ModuleRoot\internal\sql\switch-database-tier2.sql") -join [Environment]::NewLine
    }
    else {
        $commandText = (Get-Content "$script:ModuleRoot\internal\sql\switch-database-tier1.sql") -join [Environment]::NewLine
    }
    
    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.AddWithValue("@OrigName", $DatabaseName)
    $null = $sqlCommand.Parameters.AddWithValue("@NewName", $NewDatabaseName)

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the DB" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }
        
        $sqlCommand.Dispose()
    }
    
    [PSCustomObject]@{
        OldDatabaseNewName = "$DatabaseName`_original"
    }
}