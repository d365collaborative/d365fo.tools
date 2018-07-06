function Get-SQLCommand ($DatabaseServer,$DatabaseName, $SqlUser, $SqlPwd) {

    Write-verbose "Server : $DatabaseServer , Database $DatabaseName"

    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Server=$DatabaseServer;Database=$DatabaseName;User=$SqlUser;Password=$SqlPwd;Application Name=d365fo.tools"

    $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $sqlCommand.Connection = $sqlConnection

    return $sqlCommand
}