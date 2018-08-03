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

.EXAMPLE
Enable-D365User -Email "claire@contoso.com"

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

        [Parameter(Mandatory = $true, Position = 5)]
        [string]$Email

    )

    if (!$script:IsAdminRuntime -and !($PSBoundParameters.ContainsKey("SqlPwd"))) {
        Write-Host "It seems that you ran this cmdlet non-elevated and without the -SqlPwd parameter. If you don't want to supply the -SqlPwd you must run the cmdlet elevated (Run As Administrator) or simply use the -SqlPwd parameter" -ForegroundColor Yellow
        Write-Error "Running non-elevated and without the -SqlPwd parameter. Please run elevated or supply the -SqlPwd parameter." -ErrorAction Stop
    }

    [System.Data.SqlClient.SqlCommand]$sqlCommand = Get-SqlCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $sqlCommand.Connection.Open()

    $sqlCommand.CommandText = (Get-Content "$script:PSModuleRoot\internal\sql\enable-user.sql") -join [Environment]::NewLine

    Write-Verbose "Executing statement : $($sqlCommand.CommandText)"
    Write-Verbose "Parameter : @Email = $Email"
    
    $null = $sqlCommand.Parameters.AddWithValue('@Email', $Email)

    $reader = $sqlCommand.ExecuteReader()


    while ($reader.Read() -eq $true) {
        Write-Verbose "User $($reader.GetString(0)), $($reader.GetString(1)), $($reader.GetString(2)) Updated"

    }

    $reader.Close()
    $NumAffected = $reader.RecordsAffected

    Write-Verbose "Users updated : $NumAffected"


    $sqlCommand.Dispose();

}