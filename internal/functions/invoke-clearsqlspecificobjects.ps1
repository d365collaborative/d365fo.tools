Function Invoke-ClearSqlSpecificObjects ( $DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd ) {
    
    $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\clear-sqlbacpacdatabase.sql") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText

    $sqlCommand.Connection.Open()

    $null = $sqlCommand.ExecuteNonQuery()

    $sqlCommand.Connection.Close()
    $sqlCommand.Dispose()
}
