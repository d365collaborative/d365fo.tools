Function Invoke-AzureBackupRestore ($DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd, $NewDatabaseName) {
    $StartTime = Get-Date

    $newAzureDbCreated = $false

    $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd
    
    $commandText = get-content "$script:PSModuleRoot\internal\sql\newazuredbfromcopy.sql"
    
    $commandText = $commandText.Replace('@CurrentDatabase', $DatabaseName)
    $commandText = $commandText.Replace('@NewName', $NewDatabaseName)

    $sqlCommand.CommandText = $commandText

    Write-Verbose "NewDatabaseName: $NewDatabaseName"

    $sqlCommand.CommandTimeout = 0

    $sqlCommand.Connection.Open()

    Write-verbose $sqlCommand.CommandText
    
    $null = $sqlCommand.ExecuteNonQuery()

    $sqlCommand.Dispose()

    $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $commandText = get-content "$script:PSModuleRoot\internal\sql\checkfornewazuredb.sql"

    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@NewName", $NewDatabaseName)

    $sqlCommand.Connection.Open()
    
    $databaseId = -1

    while($newAzureDbCreated -eq $true){
         
        $reader = $sqlCommand.ExecuteReader()

        if ($reader.read() -eq $true) {
        
            $databaseId = $reader.GetInt(0)

            if($databaseId -gt 0)
            {
                $newAzureDbCreated = $true
            }
        }
        
        if(!$newAzureDbCreated){
            Write-Host "Tick"
            Start-Sleep -Seconds 30
        }

        $reader.close()
    }

    $EndTime = Get-Date

    $TimeSpan = New-TimeSpan -End $EndTime -Start $StartTime

    Write-Host "Time Taken inside: Invoke-AzureBackup" -ForegroundColor Green
    Write-Host "$TimeSpan" -ForegroundColor Green
}