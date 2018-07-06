Function Invoke-ClearSqlSpecificObjects ( $DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd ) {
    
    $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $commandText = get-content "$script:PSModuleRoot\internal\sql\clear-sqlbacpacdatabase.sql"

    $sqlCommand.CommandText = $commandText

    $sqlCommand.Connection.Open()

    $null = $sqlCommand.ExecuteNonQuery()

    $sqlCommand.Dispose()
}
