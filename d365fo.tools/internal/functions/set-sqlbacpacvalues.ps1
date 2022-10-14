
<#
    .SYNOPSIS
        Set the SQL Server specific values
        
    .DESCRIPTION
        Set the SQL Server specific values when restoring a bacpac file
        
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
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Set-SqlBacpacValues -DatabaseServer localhost -DatabaseName "AxDB" -SqlUser "User123" -SqlPwd "Password123"
        
        This will connect to the "AXDB" database that is available in the SQL Server instance running on the localhost.
        It will use the "User123" SQL Server credentials to connect to the SQL Server instance.
        This will set all the necessary SQL Server database options and create the needed objects in side the "AxDB" database.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Set-SqlBacpacValues {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
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
        [bool] $TrustedConnection,

        [switch] $EnableException
    )
    
    $Params = @{DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd; TrustedConnection = $TrustedConnection;
    }

    # We have learned that pooling keeps the connection open and that is not what we want
    $sqlCommand = Get-SQLCommand @Params -NoPooling

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\set-bacpacvaluessql.sql") -join [Environment]::NewLine
    $commandText = $commandText.Replace('@DATABASENAME', $DatabaseName)

    $sqlCommand.CommandText = $commandText

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $sqlCommand.ExecuteNonQuery()

        $true
    }
    catch {
        $messageString = "Something went wrong while working against the database."
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
}