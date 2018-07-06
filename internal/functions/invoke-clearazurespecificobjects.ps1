Function Invoke-ClearAzureSpecificObjects ( $DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd ) {
    
    $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $commandText = get-content "$script:PSModuleRoot\internal\sql\clear-azurebacpacdatabase.sql"

    $commandText = $commandText.Replace("@NewDatabase", "")
    
    $sqlCommand.CommandText = $commandText

    $sqlCommand.Connection.Open()

    $null = $sqlCommand.ExecuteNonQuery()

    $sqlCommand.Dispose()
}
