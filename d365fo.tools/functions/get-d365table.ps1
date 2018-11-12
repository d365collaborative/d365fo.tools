
<#
    .SYNOPSIS
        Get a table
        
    .DESCRIPTION
        Get a table either by TableName (wildcard search allowed) or by TableId
        
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
        
    .PARAMETER Id
        The specific id for the table you are looking for
        
    .EXAMPLE
        PS C:\> Get-D365Table -Name CustTable
        
        Will get the details for the CustTable
        
    .EXAMPLE
        PS C:\> Get-D365Table -Id 10347
        
        Will get the details for the table with the id 10347.
        
    .NOTES
        Tags: Table, Tables, AOT, TableId, Development
        
        Author: Mötz Jensen (@splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Get-D365Table {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string[]] $Name = "*",

        [Parameter(Mandatory = $true, ParameterSetName = 'TableId', Position = 1 )]
        [int] $Id,

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

        $sqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

        $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-tables.sql") -join [Environment]::NewLine

        $dataTable = New-Object system.Data.DataSet
        $dataAdapter = New-Object system.Data.SqlClient.SqlDataAdapter($sqlCommand)
        $dataAdapter.fill($dataTable) | Out-Null

        foreach ($localName in $Name) {
            if ($PSCmdlet.ParameterSetName -eq "Default") {
                foreach ($obj in $dataTable.Tables.Rows) {
                    if ($obj.AotName -NotLike $localName) { continue }
                    [PSCustomObject]@{
                        TableId   = $obj.TableId
                        TableName = $obj.AotName
                        SqlName   = $obj.SqlName
                    }
                }
            }
            else {
                $obj = $dataTable.Tables.Rows | Where-Object TableId -eq $Id | Select-Object -First 1
                [PSCustomObject]@{
                    TableId   = $obj.TableId
                    TableName = $obj.AotName
                    SqlName   = $obj.SqlName
                }
            }
        }
    }

    END {}
}