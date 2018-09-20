function Invoke-D365SpHelp {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 1 )]
        [string] $TableName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        # [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 2 )]
        # [Parameter(Mandatory = $true, ParameterSetName = 'SearchByNameForce', Position = 1 )]
        [string] $Schema = "dbo",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        # [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 4 )]
        # [Parameter(Mandatory = $false, ParameterSetName = 'SearchByNameForce', Position = 3 )]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 5 )]
        # [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 5 )]
        # [Parameter(Mandatory = $false, ParameterSetName = 'SearchByNameForce', Position = 4 )]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 6 )]
        # [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 6 )]
        # [Parameter(Mandatory = $false, ParameterSetName = 'SearchByNameForce', Position = 5 )]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 7 )]
        # [Parameter(Mandatory = $false, ParameterSetName = 'TableName', Position = 7 )]
        # [Parameter(Mandatory = $false, ParameterSetName = 'SearchByNameForce', Position = 6 )]
        [string] $SqlPwd = $Script:DatabaseUserPassword

    )

    begin {
    }

    process {
        if (!$script:IsAdminRuntime -and !($PSBoundParameters.ContainsKey("SqlPwd"))) {
            Write-Host "It seems that you ran this cmdlet non-elevated and without the -SqlPwd parameter. If you don't want to supply the -SqlPwd you must run the cmdlet elevated (Run As Administrator) or simply use the -SqlPwd parameter" -ForegroundColor Yellow
            Write-Error "Running non-elevated and without the -SqlPwd parameter. Please run elevated or supply the -SqlPwd parameter." -ErrorAction Stop
        }

        $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

        $strQuery = (Get-Content "$script:ModuleRoot\internal\sql\invoke-sphelp.sql") -join [Environment]::NewLine

        $sqlCommand.CommandText = $strQuery.Replace('@schema', $Schema).Replace('@table', $TableName)

        $datatable = New-Object system.Data.DataSet
        $dataadapter = New-Object system.Data.SqlClient.SqlDataAdapter($sqlcommand)
        $dataadapter.fill($datatable) | Out-Null

        foreach($datTable in $datatable.Tables)
        {
            $resFile = [System.IO.Path]::GetTempFileName()

            $datTable.Rows | Out-File $resFile

            $resFile
        }
    }

    end {
    }
}