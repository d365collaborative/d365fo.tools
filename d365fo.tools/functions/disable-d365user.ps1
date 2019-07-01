
<#
    .SYNOPSIS
        Disables the user in D365FO
        
    .DESCRIPTION
        Sets the enabled to 0 in the userinfo table.
        
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
        The search string to select which user(s) should be disabled.
        
        The parameter supports wildcards. E.g. -Email "*@contoso.com*"
        
    .EXAMPLE
        PS C:\> Disable-D365User
        
        This will Disable all users for the environment
        
    .EXAMPLE
        PS C:\> Disable-D365User -Email "claire@contoso.com"
        
        This will Disable the user with the email address "claire@contoso.com"
        
    .EXAMPLE
        PS C:\> Disable-D365User -Email "*contoso.com"
        
        This will Disable all users that matches the search "*contoso.com" in their email address
        
    .NOTES
        Tags: User, Users, Security, Configuration, Permission
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Disable-D365User {

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

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 5)]
        [string]$Email = "*"

    )

    begin {
        Invoke-TimeSignal -Start

        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

        $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd
        }

        $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

        try {
            $sqlCommand.Connection.Open()
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        
        $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\disable-user.sql") -join [Environment]::NewLine
    
        $null = $sqlCommand.Parameters.AddWithValue('@Email', $Email.Replace("*", "%"))

        try {
            Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

            $reader = $sqlCommand.ExecuteReader()
            $NumAffected = 0

            while ($reader.Read() -eq $true) {
                Write-PSFMessage -Level Verbose -Message "User $($reader.GetString(0)), $($reader.GetString(1)), $($reader.GetString(2)) Updated"
                $NumAffected++
            }

            $reader.Close()
            Write-PSFMessage -Level Verbose -Message "Users updated : $NumAffected"
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
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()

        Invoke-TimeSignal -End
    }
}