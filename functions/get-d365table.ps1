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

If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).

If Azure use the full address to the database server, e.g. server.database.windows.net

.PARAMETER DatabaseName
The name of the database

.PARAMETER SqlUser
The login name for the SQL Server instance

.PARAMETER SqlPwd
The password for the SQL Server user.

.PARAMETER Id
The specific id for the table you are looking for

.EXAMPLE
Get-D365Table -Name CustTable

Will get the details for the CustTable

.EXAMPLE
Get-D365Table -Id 10347

Will get the details for the table with the id 10347

.NOTES
The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.

Author: Mötz Jensen (@splaxi)

#>
function Get-D365Table {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string[]] $Name = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableId', Position = 2 )]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableId', Position = 3 )]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableId', Position = 4 )]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 5 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableId', Position = 5 )]
        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, ParameterSetName = 'TableId', Position = 1 )]
        [int] $Id
    )

    BEGIN {}

    PROCESS {
        if (!$script:IsAdminRuntime -and !($PSBoundParameters.ContainsKey("SqlPwd"))) {
            Write-Host "It seems that you ran this cmdlet non-elevated and without the -SqlPwd parameter. If you don't want to supply the -SqlPwd you must run the cmdlet elevated (Run As Administrator) or simply use the -SqlPwd parameter" -ForegroundColor Yellow
            Write-Error "Running non-elevated and without the -SqlPwd parameter. Please run elevated or supply the -SqlPwd parameter." -ErrorAction Stop
        }

        $sqlCommand = Get-SqlCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

        $sqlCommand.CommandText = (Get-Content "$script:PSModuleRoot\internal\sql\get-tables.sql") -join [Environment]::NewLine

        $datatable = New-Object system.Data.DataSet
        $dataadapter = New-Object system.Data.SqlClient.SqlDataAdapter($sqlcommand)
        $dataadapter.fill($datatable) | Out-Null

        foreach ($localName in $Name) {
            if ($PSCmdlet.ParameterSetName -eq "Default") {
                foreach ($obj in $datatable.Tables.Rows) {
                    if ($obj.AotName -NotLike $localName) { continue }
                    [PSCustomObject]@{
                        TableId   = $obj.TableId
                        TableName = $obj.AotName
                        SqlName   = $obj.SqlName
                    }
                }
            }
            else {
                $obj = $datatable.Tables.Rows | Where-Object TableId -eq $Id | Select-Object -First 1
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