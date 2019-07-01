
<#
    .SYNOPSIS
        Switches the 2 databases. The Old wil be renamed _original
        
    .DESCRIPTION
        Switches the 2 databases. The Old wil be renamed _original
        
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
        
    .PARAMETER NewDatabaseName
        The database that takes the DatabaseName's place
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Switch-D365ActiveDatabase -NewDatabaseName "GoldenConfig"
        
        This will switch the default database AXDB out and put "GoldenConfig" in its place instead.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Switch-D365ActiveDatabase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$SqlPwd = $Script:DatabaseUserPassword,
        
        [Parameter(Mandatory = $true, Position = 5)]
        [string]$NewDatabaseName,

        [switch] $EnableException
    )

    $Params = Get-DeepClone $PSBoundParameters
    if ($Params.ContainsKey("NewDatabaseName")) { $null = $Params.Remove("NewDatabaseName") }
    
    $dbName = Get-D365Database -Name "$DatabaseName`_original" @Params

    if (-not($null -eq $dbName)) {
        $messageString = "There <c='em'>already exists</c> a database named: <c='em'>`"$DatabaseName`_original`"</c> on the server. You need to run the <c='em'>Remove-D365Database</c> cmdlet to remove the already existing database. Re-run this cmdlet once the other database has been removed."
        Write-PSFMessage -Level Host -Message $messageString -Target $DatabaseName
        Stop-PSFFunction -Message "Stopping because database already exists on the server." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        return
    }

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $NewDatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    $SqlCommand.CommandText = "SELECT COUNT(1) FROM dbo.USERINFO WHERE ID = 'Admin'"

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)
        Write-PSFMessage -Level Verbose -Message "Testing the new database for being a valid AXDB database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()
        $null = $sqlCommand.ExecuteScalar()
    }
    catch {
        $messageString = "It seems that the new database either <c='em'>doesn't exists</c>, isn't a <c='em'>valid</c> AxDB database or your don't have enough <c='em'>permissions</c>."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }
    }
    
    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = "Master";
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    if ($DatabaseServer -like "*database.windows.net") {
        $commandText = (Get-Content "$script:ModuleRoot\internal\sql\switch-database-tier2.sql") -join [Environment]::NewLine
    }
    else {
        $commandText = (Get-Content "$script:ModuleRoot\internal\sql\switch-database-tier1.sql") -join [Environment]::NewLine
    }
    
    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.AddWithValue("@OrigName", $DatabaseName)
    $null = $sqlCommand.Parameters.AddWithValue("@NewName", $NewDatabaseName)

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)
        Write-PSFMessage -Level Verbose -Message "Switching out the AXDB database with: $NewDatabaseName." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
    }
    catch {
        $messageString = "Something went wrong while <c='em'>switching</c> out the AXDB database."
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
    
    [PSCustomObject]@{
        OldDatabaseNewName = "$DatabaseName`_original"
    }
}