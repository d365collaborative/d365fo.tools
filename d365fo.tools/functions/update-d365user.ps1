
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
        The password for the SQL Server user
        
    .PARAMETER Email
        The search string to select which user(s) should be updated.
        
        The parameter supports wildcards. E.g. -Email "*@contoso.com*"
        
    .PARAMETER Company
        The company the user should start in.
        
    .EXAMPLE
        PS C:\> Update-D365User -Email "claire@contoso.com"
        
        This will search for the user with the e-mail address claire@contoso.com and update it with needed information based on the tenant owner of the environment
        
    .EXAMPLE
        PS C:\> Update-D365User -Email "*contoso.com"
        
        This will search for all users with an e-mail address containing 'contoso.com' and update them with needed information based on the tenant owner of the environment
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Update-D365User {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [string]$DatabaseServer = $Script:DatabaseServer,

        [string]$DatabaseName = $Script:DatabaseName,

        [string]$SqlUser = $Script:DatabaseUserName,

        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Email,

        [string]$Company

    )
    begin {
        Invoke-TimeSignal -Start
        
        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

        $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd
        }

        $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection
        
        $sqlCommand_Update = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

        try {
            $sqlCommand.Connection.Open()

            $sqlCommand_Update.Connection.Open()
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    process {
        $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\get-user.sql") -join [Environment]::NewLine

        $null = $sqlCommand.Parameters.Add("@Email", $Email.Replace("*", "%"))

        $sqlCommand_Update.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\update-user.sql") -join [Environment]::NewLine

        try {
            Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)
        
            $reader = $sqlCommand.ExecuteReader()

            while ($reader.Read() -eq $true) {
                Write-PSFMessage -Level Verbose -Message "Building the update statement with the needed details."

                $userId = "$($reader.GetString($($reader.GetOrdinal("ID"))))"
                $networkAlias = "$($reader.GetString($($reader.GetOrdinal("NETWORKALIAS"))))"

                $userAuth = Get-D365UserAuthenticationDetail $networkAlias

                $null = $sqlCommand_Update.Parameters.AddWithValue("@id", $userId)
                $null = $sqlCommand_Update.Parameters.AddWithValue("@networkDomain", $userAuth["NetworkDomain"])
                $null = $sqlCommand_Update.Parameters.AddWithValue("@sid", $userAuth["SID"])
                $null = $sqlCommand_Update.Parameters.AddWithValue("@identityProvider", $userAuth["IdentityProvider"])

                $null = $sqlCommand_Update.Parameters.AddWithValue("@Company", $Company)

                Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $sqlCommand_Update)

                $null = $sqlCommand_Update.ExecuteNonQuery()

                $sqlCommand_Update.Parameters.Clear()
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally {
            $reader.close()
            $sqlCommand.Parameters.Clear()
        }
    }
    
    end {
        if ($sqlCommand_Update.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand_Update.Connection.Close()
        }

        $sqlCommand_Update.Dispose()
    
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()

        Invoke-TimeSignal -End
    }
}