Function Invoke-SqlBackupRestore {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DatabaseServer,

        [Parameter(Mandatory = $true)]
        [string] $DatabaseName, 

        [Parameter(Mandatory = $false)]
        [string] $SqlUser, 

        [Parameter(Mandatory = $false)]
        [string] $SqlPwd,
        
        [Parameter(Mandatory = $false)]
        [bool] $TrustedConnection,

        [Parameter(Mandatory = $true)]
        [string] $NewDatabaseName, 

        [Parameter(Mandatory = $true)]
        [string] $BackupDirectory
    )

    Invoke-TimeSignal -Start

    $Params = @{DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd; TrustedConnection = $UseTrustedConnection;
    }

    $sqlCommand = Get-SQLCommand @Params

    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\backuprestoredb.sql") -join [Environment]::NewLine
    $null = $sqlCommand.Parameters.Add("@CurrentDatabase", $DatabaseName)
    $null = $sqlCommand.Parameters.Add("@NewName", $NewDatabaseName)
    $null = $sqlCommand.Parameters.Add("@BackupDirectory", $BackupDirectory)

    try {
        $sqlCommand.Connection.Open()

        Write-PSFMessage -Level Verbose -Message "Executing the statement against the SQL Server" -Target $sqlCommand.CommandText
        $null = $sqlCommand.ExecuteNonQuery()    
        
        $true
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }

    Invoke-TimeSignal -End
}