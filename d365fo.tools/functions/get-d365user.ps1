
<#
    .SYNOPSIS
        Get users from the environment
        
    .DESCRIPTION
        Get all relevant user details from the Dynamics 365 for Finance & Operations
        
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
        
    .PARAMETER Email
        The search string to select which user(s) should be updated
        
        The parameter supports wildcards. E.g. -Email "*@contoso.com*"
        
        Default value is "*" to get all users
        
    .PARAMETER ExcludeSystemUsers
        Instructs the cmdlet to filter out all known system users
        
    .EXAMPLE
        PS C:\> Get-D365User
        
        This will get all users from the environment.
        
    .EXAMPLE
        PS C:\> Get-D365User -ExcludeSystemUsers
        
        This will get all users from the environment, but filter out all known system user accounts.
        
    .EXAMPLE
        PS C:\> Get-D365User -Email "*contoso.com"
        
        This will search for all users with an e-mail address containing 'contoso.com' from the environment.
        
    .NOTES
        Tags: User, Users
        
        Author: Mötz Jensen (@Splaxi)
        Author: Rasmus Andersen (@ITRasmus)
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
        [string]$Email = "*",

        [switch]$ExcludeSystemUsers

    )

    $exclude = @("DAXMDSRunner.com", "dynamics.com")

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-user.sql") -join [Environment]::NewLine

    $null = $sqlCommand.Parameters.Add("@Email", $Email.Replace("*", "%"))

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()
    
        $reader = $sqlCommand.ExecuteReader()

        while ($reader.Read() -eq $true) {
            $res = [PSCustomObject]@{
                UserId           = "$($reader.GetString($($reader.GetOrdinal("ID"))))"
                Name             = "$($reader.GetString($($reader.GetOrdinal("NAME"))))"
                NetworkAlias     = "$($reader.GetString($($reader.GetOrdinal("NETWORKALIAS"))))"
                NetworkDomain    = "$($reader.GetString($($reader.GetOrdinal("NETWORKDOMAIN"))))"
                Sid              = "$($reader.GetString($($reader.GetOrdinal("SID"))))"
                IdentityProvider = "$($reader.GetString($($reader.GetOrdinal("IDENTITYPROVIDER"))))"
                Enabled          = [bool][int]"$($reader.GetInt32($($reader.GetOrdinal("ENABLE"))))"
                Email            = "$($reader.GetString($($reader.GetOrdinal("NETWORKALIAS"))))"
                Company          = "$($reader.GetString($($reader.GetOrdinal("COMPANY"))))"
            }

            if ($ExcludeSystemUsers) {
                $temp = $res.Email.Split("@")[1]
                if ($exclude -contains $temp) {
                    continue
                }
                elseif ($res.UserId -eq 'Guest') {
                    continue
                }
            }

            $res
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