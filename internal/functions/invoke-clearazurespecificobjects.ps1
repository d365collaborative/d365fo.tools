Function Invoke-ClearAzureSpecificObjects ( $DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd ) {
    
    $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\clear-azurebacpacdatabase.sql") -join [Environment]::NewLine

    $commandText = $commandText.Replace("@NewDatabase", $DatabaseName)
    
    $sqlCommand.CommandText = $commandText

    $sqlCommand.Connection.Open()

    $null = $sqlCommand.ExecuteNonQuery()
    
    $sqlCommand.Connection.Close()
    $sqlCommand.Dispose()
}
