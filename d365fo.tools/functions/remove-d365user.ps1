
<#
    .SYNOPSIS
        Delete an user from the environment
        
    .DESCRIPTION
        Deletes the user from the database, including security configuration
        
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
        
        You have to specific the explicit email address of the user you want to remove
        
        The cmdlet will not be able to delete the ADMIN user, this is to prevent you
        from being locked out of the system.
        
    .EXAMPLE
        PS C:\> Remove-D365User -Email "Claire@contoso.com"
        
        This will move all security and user details from the user with the email address
        "Claire@contoso.com"
        
    .EXAMPLE
        PS C:\> Get-D365User -Email *contoso.com | Remove-D365User
        
        This will first get all users from the database that matches the *contoso.com
        search and pipe their emails to Remove-D365User for it to delete them.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Remove-D365User {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 5)]
        [string] $Email

    )

    BEGIN {
        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

        $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd
        }

        $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

        try {
            $SqlCommand.Connection.Open()
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }
    
    PROCESS {
        if(Test-PSFFunctionInterrupt) {return}

        $SqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\remove-user.sql") -join [Environment]::NewLine
    
        $null = $SqlCommand.Parameters.AddWithValue("@Email", $Email)
    
        try {
            Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

            $null = $SqlCommand.ExecuteNonQuery()
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }

        $SqlCommand.Parameters.Clear()
    }
    
    END {
        try {
            if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
                $sqlCommand.Connection.Close()
            }
            $sqlCommand.Dispose()
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }
}