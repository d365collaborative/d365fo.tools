
<#
    .SYNOPSIS
        Create a database copy in Azure SQL Database instance
        
    .DESCRIPTION
        Create a new database by cloning a database in Azure SQL Database instance
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN)
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
    .PARAMETER NewDatabaseName
        Name of the new / cloned database in the Azure SQL Database instance
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-AzureBackupRestore -DatabaseServer TestServer.database.windows.net -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName ExportClone
        
        This will create a database named "ExportClone" in the "TestServer.database.windows.net" Azure SQL Database instance.
        It uses the SQL credential "User123" to preform the needed actions.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
Function Invoke-AzureBackupRestore {
    [CmdletBinding()]
    [OutputType('System.Boolean')]
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
        [string] $NewDatabaseName,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    $StartTime = Get-Date
    
    $SqlConParams = @{DatabaseServer = $DatabaseServer; SqlUser = $SqlUser; SqlPwd = $SqlPwd; TrustedConnection = $false}
    $sqlCommand = Get-SqlCommand @SqlConParams -DatabaseName $DatabaseName
    
    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\newazuredbfromcopy.sql") -join [Environment]::NewLine
    
    $commandText = $commandText.Replace('@CurrentDatabase', $DatabaseName)
    $commandText = $commandText.Replace('@NewName', $NewDatabaseName)

    $sqlCommand.CommandText = $commandText

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)
        Write-PSFMessage -Level Verbose -Message "Starting the cloning process of the Azure DB." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()
        
        $null = $sqlCommand.ExecuteNonQuery()
    }
    catch {
        $messageString = "Something went wrong while <c='em'>cloning</c> the Azure DB database."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()
    }
   
    $sqlCommand = Get-SqlCommand @SqlConParams -DatabaseName "master"

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\checkfornewazuredb.sql") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@NewName", $NewDatabaseName)
    $null = $sqlCommand.Parameters.Add("@Time", $StartTime)

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)
        Write-PSFMessage -Level Verbose -Message "Start to wait for the cloning process of the Azure DB to complete."

        $sqlCommand.Connection.Open()

        $operation_row_count = 0
        #Loop every minute until we get a row, if we get a row copy is done
        while ($operation_row_count -eq 0) {
            $Reader = $sqlCommand.ExecuteReader()
            $Datatable = New-Object System.Data.DataTable
            $Datatable.Load($Reader)
            $operation_row_count = $Datatable.Rows.Count
            $time = (Get-Date).ToString("HH:mm:ss")
            Write-PSFMessage -Level Verbose -Message "Cloning not complete Sleeping for 60 seconds. [$time]"
            Start-Sleep -s 60
        }

        $true
    }
    catch {
        $messageString = "Something went wrong while <c='em'>waiting</c> for the clone process of the Azure DB database to complete."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }
    finally {
        $Reader.close()

        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()
        $Datatable.Dispose()
    }

    Invoke-TimeSignal -End
}