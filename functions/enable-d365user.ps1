<#
.SYNOPSIS
Enables the user in D365FO

.DESCRIPTION
Sets the enabled to 1 in the userinfo table. 

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

.PARAMETER Email
The search string to select which user(s) should be enabled.

Use SQL Server like syntax to get the results you expect. E.g. -Email "'%@contoso.com%'"

Default value is "%" to update all users

.EXAMPLE
Enable-D365User

This will enable all users for the environment

.EXAMPLE
Enable-D365User -Email "claire@contoso.com"

This will enable the user with the email address "claire@contoso.com"

.EXAMPLE
Enable-D365User -Email "%contoso.com"

This will enable all users that matches the search "%contoso.com" in their email address

.NOTES
Implemented on request by Paul Heisterkamp
#>
function Enable-D365User {

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

        [Parameter(Mandatory = $false, Position = 5)]
        [string]$Email = "%"

    )

    Write-PSFMessage -Level Verbose -Message "Testing if the runtime is elevated or SqlPwd was supplied."

    if (!$script:IsAdminRuntime -and !($PSBoundParameters.ContainsKey("SqlPwd"))) {
        Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c> and without the <c='em'>-SqlPwd parameter</c>. If you don't want to supply the -SqlPwd you must run the cmdlet elevated (Run As Administrator) otherwise simply use the -SqlPwd parameter"

        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    [System.Data.SqlClient.SqlCommand]$sqlCommand = Get-SqlCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $sqlCommand.Connection.Open()

    $sqlCommand.CommandText = (Get-Content "$script:PSModuleRoot\internal\sql\enable-user.sql") -join [Environment]::NewLine

    Write-PSFMessage -Level Verbose -Message "Building statement : $($sqlCommand.CommandText)"
    Write-PSFMessage -Level Verbose -Message "Parameter : @Email = $Email"
    
    $null = $sqlCommand.Parameters.AddWithValue('@Email', $Email)

    Write-PSFMessage -Level Verbose -Message "Executing the update statement against the database."
    $reader = $sqlCommand.ExecuteReader()

    while ($reader.Read() -eq $true) {
        Write-PSFMessage -Level Verbose -Message "User $($reader.GetString(0)), $($reader.GetString(1)), $($reader.GetString(2)) Updated"
    }

    $reader.Close()
    $NumAffected = $reader.RecordsAffected

    Write-PSFMessage -Level Verbose -Message "Users updated : $NumAffected"
    $sqlCommand.Connection.Close()
    $sqlCommand.Dispose();
}