
<#
    .SYNOPSIS
        Backup & Restore SQL Server database
        
    .DESCRIPTION
        Backup a database and restore it back into the SQL Server
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
    .PARAMETER TrustedConnection
        Should the connection use a Trusted Connection or not
        
    .PARAMETER NewDatabaseName
        Name of the new (restored) database
        
    .PARAMETER BackupDirectory
        Path to a directory that can store the backup file
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-SqlBackupRestore -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName "ExportClone" -BackupDirectory "C:\temp\d365fo.tools\sqlbackup"
        
        This will backup the AxDB database and place the backup file inside the "c:\temp\d365fo.tools\sqlbackup" directory.
        The backup file will the be used to restore into a new database named "ExportClone".
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
Function Invoke-SqlBackupRestore {
    [CmdletBinding()]
    [OutputType('System.Boolean')]
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
        [boolean] $TrustedConnection,

        [Parameter(Mandatory = $true)]
        [string] $NewDatabaseName,

        [Parameter(Mandatory = $true)]
        [string] $BackupDirectory,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    $Params = @{DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd; TrustedConnection = $TrustedConnection;
    }

    $sqlCommand = Get-SQLCommand @Params

    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\backuprestoredb.sql") -join [Environment]::NewLine
    $null = $sqlCommand.Parameters.Add("@CurrentDatabase", $DatabaseName)
    $null = $sqlCommand.Parameters.Add("@NewName", $NewDatabaseName)
    $null = $sqlCommand.Parameters.Add("@BackupDirectory", $BackupDirectory)

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()
        
        $null = $sqlCommand.ExecuteNonQuery()
        
        $true
    }
    catch {
        $messageString = "Something went wrong while doing <c='em'>backup / restore</c> against the database."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }
    finally {
        
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }

    Invoke-TimeSignal -End
}