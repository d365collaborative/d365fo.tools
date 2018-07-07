<#
.SYNOPSIS
Updates the user details in the database

.DESCRIPTION
Is capable of updating all the user details inside the UserInfo table to enable a user to sign in

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
The search string to select which user(s) should be updated.

Use SQL Server like syntax to get the results you expect. E.g. -Email "'%@contoso.com%'"

.EXAMPLE
Update-User -Email "claire@contoso.com"

This will search for the user with the e-mail address claire@contoso.com and update it with needed information based on the tenant owner of the environment

.EXAMPLE
Update-User -Email "%contoso.com%"

This will search for all users with an e-mail address containing 'contoso.com' and update them with needed information based on the tenant owner of the environment

.NOTES
General notes
#>
function Update-User {
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, Position = 5)]
        [string]$Email

    )

    [System.Data.SqlClient.SqlCommand]$sqlCommand = Get-SqlCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $sqlCommand.Connection.Open()

    $sqlCommand.CommandText = (Get-Content "$script:PSModuleRoot\internal\sql\get-user.sql") -join [Environment]::NewLine
    $null = $sqlCommand.Parameters.Add("@Email", $Email)

    [System.Data.SqlClient.SqlCommand]$sqlCommand_Update = Get-SqlCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $sqlCommand_Update.Connection.Open()

    $sqlCommand_Update.CommandText = (Get-Content  "$script:PSModuleRoot\internal\sql\update-user.sql") -join [Environment]::NewLine

    $reader = $sqlCommand.ExecuteReader()

    while ($reader.Read() -eq $true) {
        $userId = $reader.GetString(0)
        $networkAlias = $reader.GetString(1)

        $userAuth = Get-UserAuthenticationDetail $networkAlias

        $null = $sqlCommand_Update.Parameters.Add("@id", $userId)
        $null = $sqlCommand_Update.Parameters.Add("@networkDomain", $userAuth["NetworkDomain"])
        $null = $sqlCommand_Update.Parameters.Add("@sid", $userAuth["SID"])
        $null = $sqlCommand_Update.Parameters.Add("@identityProvider", $userAuth["IdentityProvider"])

        write-verbose "Updating user $userId"
        
        $null = $sqlCommand_Update.ExecuteNonQuery()

        $sqlCommand_Update.Parameters.Clear()
    }

    $sqlCommand_Update.Dispose()
    $sqlCommand.Dispose()
}