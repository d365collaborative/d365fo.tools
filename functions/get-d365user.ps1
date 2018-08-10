<#
.SYNOPSIS
Get users from the environment

.DESCRIPTION
Get all relevant user details from the Dynamics 365 for Finance & Operations

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
Get-D365User

This will get all users from the environment

.EXAMPLE
Update-D365User -Email "%contoso.com%"

This will search for all users with an e-mail address containing 'contoso.com' from the environment

.NOTES
General notes
#>
function Get-D365User {
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
        Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet non-elevated and without the -SqlPwd parameter. If you don't want to supply the -SqlPwd you must run the cmdlet elevated (Run As Administrator) or simply use the -SqlPwd parameter"

        Write-Error "Running non-elevated and without the -SqlPwd parameter. Please run elevated or supply the -SqlPwd parameter." -ErrorAction Stop
    }

    [System.Data.SqlClient.SqlCommand] $sqlCommand = Get-SqlCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $sqlCommand.Connection.Open()

    $sqlCommand.CommandText = (Get-Content "$script:PSModuleRoot\internal\sql\get-user.sql") -join [Environment]::NewLine
    
    Write-PSFMessage -Level Verbose -Message "Building statement : $($sqlCommand.CommandText)"
    Write-PSFMessage -Level Verbose -Message "Parameter : @Email = $Email"

    $null = $sqlCommand.Parameters.Add("@Email", $Email)

    Write-PSFMessage -Level Verbose -Message "Executing the select statement against the database."

    [System.Data.SqlClient.SqlDataReader] $reader = $sqlCommand.ExecuteReader()

    Write-PSFMessage -Level Verbose -Message "Building the result set."
    while ($reader.Read() -eq $true) {
        [PSCustomObject]@{
            UserId           = "$($reader.GetString($($reader.GetOrdinal("ID"))))"
            Name             = "$($reader.GetString($($reader.GetOrdinal("NAME"))))"
            NetworkAlias     = "$($reader.GetString($($reader.GetOrdinal("NETWORKALIAS"))))"
            NetworkDomain    = "$($reader.GetString($($reader.GetOrdinal("NETWORKDOMAIN"))))"
            Sid              = "$($reader.GetString($($reader.GetOrdinal("SID"))))"
            IdentityProvider = "$($reader.GetString($($reader.GetOrdinal("IDENTITYPROVIDER"))))"
            Enable           = [bool][int]"$($reader.GetInt32($($reader.GetOrdinal("ENABLE"))))"
         }
    }
}