
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
        
    .PARAMETER SourceDatabaseName
        The database that takes the DatabaseName's place
        
    .PARAMETER DestinationSuffix
        The suffix that you want to append onto the database that is being switched out (DestinationDatabaseName / DatabaseName)
        
        The default value is "_original" to mimic the official guides from Microsoft
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Switch-D365ActiveDatabase -SourceDatabaseName "GoldenConfig"
        
        This will switch the default database AXDB out and put "GoldenConfig" in its place instead.
        It will use the default value for DestinationSuffix which is "_original".
        The destination database "AXDB" will be renamed to "AXDB_original".
        The GoldenConfig database will be renamed to "AXDB".
        
    .EXAMPLE
        PS C:\> Switch-D365ActiveDatabase -SourceDatabaseName "AXDB_original" -DestinationSuffix "_reverted"
        
        This will switch the default database AXDB out and put "AXDB_original" in its place instead.
        It will use the "_reverted" value for DestinationSuffix parameter.
        The destination database "AXDB" will be renamed to "AXDB_reverted".
        The "AXDB_original" database will be renamed to "AXDB".
        
        This is used when you did a switch already and need to switch back to the original database.
        
        This example assumes that the used the first example to switch in the GoldenConfig database with default parameters.
        
    .NOTES
        
        Author: Mötz Jensen (@Splaxi)
        
        Author: Rasmus Andersen (@ITRasmus)
        
#>
function Switch-D365ActiveDatabase {
    [CmdletBinding()]
    param (
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Alias('DestinationDatabaseName')]
        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,
        
        [Parameter(Mandatory = $true)]
        [Alias('NewDatabaseName')]
        [string] $SourceDatabaseName,

        [string] $DestinationSuffix = "_original",

        [switch] $EnableException
    )

    $dbToBeName = "$DatabaseName$DestinationSuffix"

    $SqlParamsToBe = @{ DatabaseServer = $DatabaseServer; DatabaseName = "master";
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }
    
    $dbName = Get-D365Database -Name "$dbToBeName" @SqlParamsToBe

    if (-not($null -eq $dbName)) {
        $messageString = "There <c='em'>already exists</c> a database named: <c='em'>`"$dbToBeName`"</c> on the server. You need to run the <c='em'>Remove-D365Database</c> cmdlet to remove the already existing database. Re-run this cmdlet once the other database has been removed."
        Write-PSFMessage -Level Host -Message $messageString -Target $dbToBeName
        Stop-PSFFunction -Message "Stopping because database already exists on the server." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        return
    }

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParamsSource = @{ DatabaseServer = $DatabaseServer; DatabaseName = $SourceDatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParamsSource -TrustedConnection $UseTrustedConnection

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
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }
    }
    
    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = "master";
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

    $null = $sqlCommand.Parameters.AddWithValue("@DestinationName", $DatabaseName)
    $null = $sqlCommand.Parameters.AddWithValue("@SourceName", $SourceDatabaseName)
    $null = $sqlCommand.Parameters.AddWithValue("@ToBeName", $dbToBeName)

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)
        Write-PSFMessage -Level Verbose -Message "Switching out the $DatabaseName database with: $SourceDatabaseName." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
    }
    catch {
        $messageString = "Something went wrong while <c='em'>switching</c> out the AXDB database."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }
        
        $sqlCommand.Dispose()
    }
    
    [PSCustomObject]@{
        OldDatabaseNewName = "$dbToBeName"
    }
}