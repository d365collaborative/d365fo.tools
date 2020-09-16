
<#
    .SYNOPSIS
        Get databases from the server
        
    .DESCRIPTION
        Get the names of databases on either SQL Server or in Azure SQL Database instance
        
    .PARAMETER Name
        Name of the database that you are looking for
        
        Default value is "*" which will show all databases
        
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
        PS C:\> Get-D365Database
        
        This will show all databases on the default SQL Server / Azure SQL Database instance.
        
    .EXAMPLE
        PS C:\> Get-D365Database -Name AXDB_ORIGINAL
        
        This will show if the AXDB_ORIGINAL database exists on the default SQL Server / Azure SQL Database instance.
        
    .NOTES
        Tags: Database, DB, Servicing
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365Database {
    [CmdletBinding()]
    [OutputType('[PsCustomObject]')]
    param (
        [string[]] $Name = "*",

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword
    )

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = "master";
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $sqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-database.sql") -join [Environment]::NewLine

    try {
        $sqlCommand.Connection.Open()
    
        $reader = $sqlCommand.ExecuteReader()

        while ($reader.Read() -eq $true) {
            $res = [PSCustomObject]@{
                Name             = "$($reader.GetString($($reader.GetOrdinal("NAME"))))"
            }

            if ($res.Name -NotLike $Name) { continue }

            $res
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