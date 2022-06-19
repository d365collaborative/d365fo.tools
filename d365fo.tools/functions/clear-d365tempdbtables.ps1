
<#
    .SYNOPSIS
        Cleanup TempDB tables in Microsoft Dynamics 365 for Finance and Operations environment
        
    .DESCRIPTION
        This will cleanup X days of TempDB tables
        
        The reason behind this process is that sp_updatestats takes significantly longer depending on the number of TempDB tables in the system
        
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
        
    .PARAMETER Days
        Temp tables older than this Days input will be dropped
        
        The default value is 7 (days)
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Clear-D365TempDbTables -Days 7
        
        This will cleanup old tempdb tables.
        It will use 7 as the Days parameter.
        
        The remaining parameters will use their default values, which are provided by the tools.
        
    .LINK
        https://msdyn365fo.wordpress.com/2019/12/18/cleanup-tempdb-tables-in-a-msdyn365fo-sandbox-environment/
        
    .LINK
        https://github.com/PaulHeisterkamp/d365fo.blog/blob/master/Tools/SQL/DropTempDBTables.sql
        
    .NOTES
        
        Author: Alex Kwitny (@AlexOnDAX)
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet is based on the findings from Paul Heisterkamp (@braul)
        
        See his blog for more info:
        https://msdyn365fo.wordpress.com/2019/12/18/cleanup-tempdb-tables-in-a-msdyn365fo-sandbox-environment/
#>

function Clear-D365TempDbTables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param
    (
        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [int] $Days = 7,
        
        [switch] $EnableException
    )
    
    Invoke-TimeSignal -Start

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters
    
    $Params = @{DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd; TrustedConnection = $UseTrustedConnection;
    }

    $sqlCommand = Get-SQLCommand @Params

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\clear-d365tempdbtables.sql") -join [Environment]::NewLine
    $commandText = $commandText.Replace('@Days', $Days)

    $sqlCommand.CommandText = $commandText

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
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

    Invoke-TimeSignal -End
}