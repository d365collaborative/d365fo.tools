function Invoke-D365SpHelp {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 1 )]
        [string] $TableName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [string] $Schema = "dbo",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 5 )]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 6 )]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 7 )]
        [string] $SqlPwd = $Script:DatabaseUserPassword

    )

    begin {
        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

        $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd 
        }

        $sqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection
    }

    process {
        $strQuery = (Get-Content "$script:ModuleRoot\internal\sql\invoke-sphelp.sql") -join [Environment]::NewLine

        $sqlCommand.CommandText = $strQuery.Replace('@schema', $Schema).Replace('@table', $TableName)

        $datatable = New-Object system.Data.DataSet
        $dataadapter = New-Object system.Data.SqlClient.SqlDataAdapter($sqlcommand)
        $dataadapter.fill($datatable) | Out-Null

        foreach($datTable in $datatable.Tables)
        {
            $resFile = [System.IO.Path]::GetTempFileName()

            $datTable.Rows | Out-File $resFile

            [PSCustomObject]@{
                File = $resFile
            } 
        }
    }

    end {
    }
}