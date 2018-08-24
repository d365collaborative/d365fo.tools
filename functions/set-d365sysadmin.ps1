<#
.SYNOPSIS
Set a user to sysadmin

.DESCRIPTION
Set a user to sysadmin inside the SQL Server

.PARAMETER User
The user that you want to make sysadmin

Most be well formatted server\user or domain\user.

Default value is: machinename\administrator

.PARAMETER DatabaseServer
The name of the database server

If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).

If Azure use the full address to the database server, e.g. server.database.windows.net

.PARAMETER DatabaseName
The name of the database

.PARAMETER SqlUser
The login name for the SQL Server instance

.PARAMETER SqlPwd
The password for the SQL Server user.

.EXAMPLE
Set-D365SysAdmin

This will configure the local administrator on the machine as a SYSADMIN inside SQL Server 

For this to run you need to be running it from a elevated console

.EXAMPLE
Set-D365SysAdmin -SqlPwd Test123

This will configure the local administrator on the machine as a SYSADMIN inside SQL Server.
It will logon as the default SqlUser but use the provided SqlPwd. 

This can be run from a non-elevated console

.NOTES
General notes
#>
function Set-D365SysAdmin {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $false, Position = 1)]
        [string] $User = "$env:computername\administrator",

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 5)]
        [string] $SqlPwd = $Script:DatabaseUserPassword   
    )
    
    begin {
    }
    
    process {

        Write-PSFMessage -Level Debug -Message "Testing if running either elevated or with -SqlPwd set."
        if (!$script:IsAdminRuntime -and !($PSBoundParameters.ContainsKey("SqlPwd"))) {
            Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c> and without the <c='em'>-SqlPwd parameter</c>. If you don't want to supply the -SqlPwd you must run the cmdlet elevated (Run As Administrator) otherwise simply use the -SqlPwd parameter"
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }

        Write-PSFMessage -Level Debug -Message "Building the sql statement."
        $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\set-sysadmin.sql") -join [Environment]::NewLine
        $commandText = $commandText.Replace('@USER', $User)

        $sqlCommand = Get-SQLCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

        $sqlCommand.CommandText = $commandText

        $sqlCommand.Connection.Open()

        Write-PSFMessage -Level Debug -Message "Execution the sql statement." -Target $commandText
        $null = $sqlCommand.ExecuteNonQuery()
        
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }
    
    end {
    }
}