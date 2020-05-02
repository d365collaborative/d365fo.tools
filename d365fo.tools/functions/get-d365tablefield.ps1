
<#
    .SYNOPSIS
        Get a field from table
        
    .DESCRIPTION
        Get a field either by FieldName (wildcard search allowed) or by FieldId
        
    .PARAMETER TableId
        The id of the table that the field belongs to
        
    .PARAMETER Name
        Name of the field that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Account*"
        
        Default value is "*" which will search for all fields
        
    .PARAMETER FieldId
        Id of the field that you are looking for
        
        Type is integer
        
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
        
    .PARAMETER TableName
        Name of the table that the field belongs to
        
        Search will only return the first hit (unordered) and work against that hit
        
    .PARAMETER IncludeTableDetails
        Switch options to enable the result set to include extended details
        
    .PARAMETER SearchAcrossTables
        Switch options to force the cmdlet to search across all tables when looking for the field
        
    .EXAMPLE
        PS C:\> Get-D365TableField -TableId 10347
        
        Will get all field details for the table with id 10347.
        
    .EXAMPLE
        PS C:\> Get-D365TableField -TableName CustTable
        
        Will get all field details for the CustTable table.
        
    .EXAMPLE
        PS C:\> Get-D365TableField -TableId 10347 -FieldId 175
        
        Will get the details for the field with id 175 that belongs to the table with id 10347.
        
    .EXAMPLE
        PS C:\> Get-D365TableField -TableId 10347 -Name "VATNUM"
        
        Will get the details for the "VATNUM" that belongs to the table with id 10347.
        
    .EXAMPLE
        PS C:\> Get-D365TableField -TableId 10347 -Name "VAT*"
        
        Will get the details for all fields that fits the search "VAT*" that belongs to the table with id 10347.
        
    .EXAMPLE
        PS C:\> Get-D365TableField -Name AccountNum -SearchAcrossTables
        
        Will search for the AccountNum field across all tables.
        
    .EXAMPLE
        PS C:\> Get-D365TableField -TableName CustTable -IncludeTableDetails
        
        Will get all field details for the CustTable table.
        Will include table details in the output.
        
    .NOTES
        Tags: Table, Tables, Fields, TableField, Table Field, TableName, TableId
        
        Author: Mötz Jensen (@splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
        
#>
function Get-D365TableField {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 1 )]
        [int] $TableId,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 2 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'SearchByNameForce', Position = 1 )]
        [string] $Name = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 3 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableName', ValueFromPipelineByPropertyName = $true, Position = 3 )]
        [int] $FieldId,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 4 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'SearchByNameForce', Position = 3 )]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 5 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 5 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'SearchByNameForce', Position = 4 )]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 6 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 6 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'SearchByNameForce', Position = 5 )]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 7 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 7 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'SearchByNameForce', Position = 6 )]
        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, ParameterSetName = 'TableName', Position = 1 )]
        [string] $TableName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'TableName')]
        [switch] $IncludeTableDetails,

        [Parameter(Mandatory = $true, ParameterSetName = 'SearchByNameForce', Position = 2 )]
        [switch] $SearchAcrossTables
    )
    BEGIN {
        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

        $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd
        }

        $sqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    }
    
    PROCESS {
        if ($PSCmdlet.ParameterSetName -eq "TableName") {
            $TableId = (Get-D365Table -Name $TableName | Select-Object -First 1).TableId
        }

        if ($SearchAcrossTables) {
            $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-alltablefields.sql") -join [Environment]::NewLine
        }
        else {
            $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-tablefields.sql") -join [Environment]::NewLine
            $null = $sqlCommand.Parameters.Add("@TableId", $TableId)
        }

        $dataTable = New-Object system.Data.DataSet
        $dataAdapter = New-Object system.Data.SqlClient.SqlDataAdapter($sqlCommand)
        $dataAdapter.fill($dataTable) | Out-Null

        foreach ($obj in $dataTable.Tables.Rows) {
            if ($obj.FieldId -eq 0) {
                $TableName = $obj.AotName

                continue
            }

            if ($PSBoundParameters.ContainsKey("FieldId")) {
                if ($obj.FieldId -NotLike $FieldId) { continue }
            }
            else {
                if ($obj.AotName -NotLike $Name) { continue }
            }
            $res = [PSCustomObject]@{
                FieldId   = $obj.FieldId
                FieldName = $obj.AotName
                SqlName   = $obj.SqlName
            }

            if ($IncludeTableDetails) {
                $res | Add-Member -MemberType NoteProperty -Name 'TableId' -Value $obj.TableId
                $res | Add-Member -MemberType NoteProperty -Name 'TableName' -Value $TableName
            }
            if ($SearchAcrossTables) {
                $res | Add-Member -MemberType NoteProperty -Name 'TableId' -Value $obj.TableId
            }

            $res
        }
    }

    END {}
}