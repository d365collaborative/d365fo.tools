
<#
    .SYNOPSIS
        Get the sequence object for table
        
    .DESCRIPTION
        Get the sequence details for tables
        
    .PARAMETER TableName
        Name of the table that you want to work against
        
        Accepts wildcards for searching. E.g. -TableName "Cust*"
        
        Default value is "*" which will search for all tables
        
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
        PS C:\> Get-D365TableSequence | Format-Table
        
        This will get all the sequence details for all tables inside the database.
        It will format the output as a table for better overview.
        
    .EXAMPLE
        PS C:\> Get-D365TableSequence -TableName "Custtable" | Format-Table
        
        This will get the sequence details for the CustTable in the database.
        It will format the output as a table for better overview.
        
    .EXAMPLE
        PS C:\> Get-D365TableSequence -TableName "Cust*" | Format-Table
        
        This will get the sequence details for all tables that matches the search "Cust*" in the database.
        It will format the output as a table for better overview.
        
    .EXAMPLE
        PS C:\> Get-D365Table -Name CustTable | Get-D365TableSequence | Format-Table
        
        This will get the table details from the Get-D365Table cmdlet and pipe that into Get-D365TableSequence.
        This will get the sequence details for the CustTable in the database.
        It will format the output as a table for better overview.
        
    .NOTES
        Tags: Table, RecId, Sequence, Record Id
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365TableSequence {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 1 )]
        [Alias('Name')]
        [string] $TableName = "*",

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 4 )]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 5 )]
        [string] $SqlPwd = $Script:DatabaseUserPassword
    )
    BEGIN {}
    
    PROCESS {
        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

        $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd
        }

        $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection
        $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-tablesequence.sql") -join [Environment]::NewLine
        $null = $sqlCommand.Parameters.AddWithValue('@TableName', $TableName.Replace("*", "%"))
        
        $datatable = New-Object system.Data.DataSet
        $dataadapter = New-Object system.Data.SqlClient.SqlDataAdapter($sqlcommand)
        $dataadapter.fill($datatable) | Out-Null

        foreach ($obj in $datatable.Tables.Rows) {
            $res = [PSCustomObject]@{
                SequenceName   = $obj.sequence_name
                TableName = $obj.table_name
                StartValue   = $obj.start_value
                Increment = $obj.increment
                MinimumValue = $obj.minimum_value
                MaximumValue = $obj.maximum_value
                IsCached = $obj.is_cached
                CacheSize = $obj.cache_size
                CurrentValue = $obj.current_value
            }

            $res
        }
    }

    END {}
}