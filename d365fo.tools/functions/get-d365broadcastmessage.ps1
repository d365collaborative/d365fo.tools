
<#
    .SYNOPSIS
        Get broadcast message from the D365FO environment
        
    .DESCRIPTION
        Get broadcast message from the D365FO environment by looking into the database table
        
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
        
    .PARAMETER ExcludeExpired
        Exclude all the records that has already expired
        
    .EXAMPLE
        PS C:\> Get-D365BroadcastMessage
        
        This will display all the broadcast message records from the SysBroadcastMessage table.
        
    .EXAMPLE
        PS C:\> Get-D365BroadcastMessage -ExcludeExpired
        
        This will display all active the broadcast message records from the SysBroadcastMessage table.
        
    .NOTES
        Tags: Broadcast, Message, SysBroadcastMessage, Servicing, Message, Users, Environment
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365BroadcastMessage {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [switch] $ExcludeExpired
    )

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    if ($ExcludeExpired) {
        $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-broadcastmessageactive.sql") -join [Environment]::NewLine
    }
    else {
        $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-broadcastmessage.sql") -join [Environment]::NewLine
    }

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()
    
        $reader = $sqlCommand.ExecuteReader()

        while ($reader.Read() -eq $true) {
            [PSCustomObject]@{
                StartTime    = [System.TimeZoneInfo]::ConvertTimeFromUtc($($reader.GetDateTime($($reader.GetOrdinal("FROMDATETIME")))), [System.TimeZoneInfo]::Local)
                EndTime      = [System.TimeZoneInfo]::ConvertTimeFromUtc($($reader.GetDateTime($($reader.GetOrdinal("TODATETIME")))), [System.TimeZoneInfo]::Local)
                StartTimeUtc = [System.TimeZoneInfo]::ConvertTimeFromUtc($($reader.GetDateTime($($reader.GetOrdinal("TODATETIME")))), [System.TimeZoneInfo]::Utc)
                EndTimeUtc   = [System.TimeZoneInfo]::ConvertTimeFromUtc($($reader.GetDateTime($($reader.GetOrdinal("TODATETIME")))), [System.TimeZoneInfo]::Utc)
                AOSId        = "$($reader.GetString($($reader.GetOrdinal("AOSID"))))"
            }
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $reader.close()

        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()
    }
}