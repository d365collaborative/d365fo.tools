Function Invoke-AzureBackupRestore  {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DatabaseServer,

        [Parameter(Mandatory = $true)]
        [string] $DatabaseName, 

        [Parameter(Mandatory = $true)]
        [string] $SqlUser, 

        [Parameter(Mandatory = $true)]
        [string] $SqlPwd,

        [Parameter(Mandatory = $true)]
        [string] $NewDatabaseName
    )

    Invoke-TimeSignal -Start

    $StartTime = Get-Date
    
    $SqlConParams = @{DatabaseServer = $DatabaseServer; SqlUser = $SqlUser; SqlPwd = $SqlPwd; TrustedConnection = $false}
    $sqlCommand = Get-SQLCommand @SqlConParams -DatabaseName $DatabaseName
    
    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\newazuredbfromcopy.sql") -join [Environment]::NewLine
    
    $commandText = $commandText.Replace('@CurrentDatabase', $DatabaseName)
    $commandText = $commandText.Replace('@NewName', $NewDatabaseName)

    $sqlCommand.CommandText = $commandText

    try {
        $sqlCommand.Connection.Open()

        Write-Verbose $sqlCommand.CommandText
        
        $null = $sqlCommand.ExecuteNonQuery()       
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while creating the copy of the Azure DB" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }
   
    $sqlCommand = Get-SQLCommand @SqlConParams -DatabaseName "master"

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\checkfornewazuredb.sql") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@NewName", $NewDatabaseName)
    $null = $sqlCommand.Parameters.Add("@Time", $StartTime)

    try {
        $sqlCommand.Connection.Open()

        $operation_row_count = 0
        #Loop every minute until we get a row, if we get a row copy is done
        while ($operation_row_count -eq 0) {
            Write-PSFMessage -Level Verbose -Message "Waiting for the creation of the copy."
            $Reader = $sqlCommand.ExecuteReader()
            $Datatable = New-Object System.Data.DataTable
            $Datatable.Load($Reader)
            $operation_row_count = $Datatable.Rows.Count
            Start-Sleep -s 60
        }

        $true
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while checking for the new copy of the Azure DB" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $Reader.Close()
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
        $Datatable.Dispose()
    }

    Invoke-TimeSignal -End
}