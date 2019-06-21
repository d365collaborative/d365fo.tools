
<#
    .SYNOPSIS
        Add new user from outside client's AAD (Azure Active Directory)
        
    .DESCRIPTION
        Add new user with system user and system administrator role.
        The idea behind of this script its to help add partner users into client test/dev environments after a database refresh.

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
        
    .PARAMETER Id
        New user id
        
    .PARAMETER Name
        New user name
        
    .PARAMETER Email
        New user email address

    .PARAMETER SID
        New user SID

	.PARAMETER Company
        New user default company

		Default value is "DAT"

	.PARAMETER Enabled
        New user enabled status

        Default value is "true"
        
    .PARAMETER Language
        New user status

        Default value is "en-us"
        
    .EXAMPLE

        PS Add-D365ExternalUser -Id 'newuser' -Name 'My new user' -Email 'newuser@contoso.com' -SID 'S-1-19-000000000-...-000000000'
        
        This will create a new user.
        Following roles will be assigned to new user: System user and system administrator.
        If user already exists, this script will try to assigned above roles to the user.
        If user already exists and its assigned to both roles, nothing else will happen.
        For the time being, this function does not fetch user's SID. Developers need to have this information in advance.
        
        This examples contains only mandatory parameters.
        
    .NOTES
        Tags: User, Users, Security, Configuration, Permission
        
        Author: Anderson Joyle (@AndersonJoyle)
#>

function Add-D365ExternalUser {
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

		[Parameter(Mandatory = $true)]
        [string] $Id,

		[Parameter(Mandatory = $true)]
        [string] $Name,

		[Parameter(Mandatory = $true)]
        [string] $Email,

		[Parameter(Mandatory = $true)]
        [string] $SID,

		[Parameter(Mandatory = $false)]
        [int] $Enabled = 1,

		[Parameter(Mandatory = $false)]
        [string] $Company = "DAT",

		[Parameter(Mandatory = $false)]
        [string] $Language = "en-us"
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

        $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\add-externaluser.sql") -join [Environment]::NewLine
            
        $null = $sqlCommand.Parameters.AddWithValue('@Id', $Id)
		$null = $sqlCommand.Parameters.AddWithValue('@Name', $Name)
		$null = $sqlCommand.Parameters.AddWithValue('@Email', $Email)
		$null = $sqlCommand.Parameters.AddWithValue('@SID', $SID)
		$null = $sqlCommand.Parameters.AddWithValue('@Enabled', $Enabled)
		$null = $sqlCommand.Parameters.AddWithValue('@Company', $Company)
		$null = $sqlCommand.Parameters.AddWithValue('@Language', $Language)
		$null = $sqlCommand.Parameters.AddWithValue('@Provider', 'https://sts.windows.net/' + $Email.split('@')[1])

        try {
            Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

            $reader = $sqlCommand.ExecuteReader()
            $reader.Close()

            Write-PSFMessage -Level Verbose -Message "Done!"
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