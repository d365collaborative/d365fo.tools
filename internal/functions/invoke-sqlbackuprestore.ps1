Function Invoke-SqlBackupRestore ($DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd, $NewDatabaseName) {
    $StartTime = Get-Date

    $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\backuprestoredb.sql") -join [Environment]::NewLine
   
    $sqlCommand.CommandText = $commandText

    Write-Verbose "BackupDirectory is: $BackupDirectory"
    Write-Verbose "NewDatabaseName: $NewDatabaseName"

    $null = $sqlCommand.Parameters.Add("@CurrentDatabase", $DatabaseName)
    $null = $sqlCommand.Parameters.Add("@NewName", $NewDatabaseName)
    $null = $sqlCommand.Parameters.Add("@BackupDirectory", $BackupDirectory)
   
    $sqlCommand.CommandTimeout = 0

    $sqlCommand.Connection.Open()

    Write-verbose $sqlCommand.CommandText
    
    $null = $sqlCommand.ExecuteNonQuery()
    
    $sqlCommand.Connection.Close()
    $sqlCommand.Dispose()

    $EndTime = Get-Date

    $TimeSpan = New-TimeSpan -End $EndTime -Start $StartTime

    Write-Host "Time Taken inside: Invoke-SqlBackupRestore" -ForegroundColor Green
    Write-Host "$TimeSpan" -ForegroundColor Green
}