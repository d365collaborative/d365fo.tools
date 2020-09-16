
<#
    .SYNOPSIS
        Get table that is taking part of Change Tracking
        
    .DESCRIPTION
        Get table(s) that is taking part of the SQL Server Change Tracking mechanism
        
    .PARAMETER Name
        Name of the table that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Cust*"
        
        Default value is "*" which will search for all tables
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN)
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
    .EXAMPLE
        PS C:\> Get-D365TablesInChangedTracking
        
        This will list all tables that are taking part in the SQL Server Change Tracking.
        
    .EXAMPLE
        PS C:\> Get-D365TablesInChangedTracking -Name CustTable
        
        This will search for a table in the list of tables that are taking part in the SQL Server Change Tracking.
        It will use the CustTable as the search pattern while searching for the table.
        
    .NOTES
        Tags: Table, Change Tracking, Tablename, DMF, DIXF
        
        Author: Mötz Jensen (@splaxi)
        
#>
function Get-D365TablesInChangedTracking {
    [CmdletBinding()]
    param (
        [string] $Name = "*",

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword
    )

    PROCESS {

        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

        $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd
        }

        $sqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

        $commandText = (Get-Content "$script:ModuleRoot\internal\sql\get-tablesinchangedtracking.sql") -join [Environment]::NewLine
        $commandText = $commandText.Replace('@DATABASENAME', $DatabaseName)

        $sqlCommand.CommandText = $commandText

        $dataTable = New-Object system.Data.DataSet
        $dataAdapter = New-Object system.Data.SqlClient.SqlDataAdapter($sqlCommand)
        $dataAdapter.fill($dataTable) | Out-Null

        foreach ($obj in $dataTable.Tables.Rows) {
            if ($obj.name -NotLike $Name) { continue }

            [PSCustomObject]@{
                TableName = $obj.name
            }
        }
    }
}