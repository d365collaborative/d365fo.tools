
<#
    .SYNOPSIS
        Add new user from outside AAD (Azure Active Directory)
        
    .DESCRIPTION
        Add new user with system administrator role
        
    .PARAMETER Id
        New user id
        
    .PARAMETER Name
        New user name
        
    .PARAMETER Email
        New user email address

	.PARAMETER Company
        New user default company

		Default value is "DAT"

	.PARAMETER Enabled
        New user status

		Default value is "true"
        
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
        
    .EXAMPLE
        PS C:\> Add-D365LcsEnvironment -Name "UAT" -ProjectId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will create a new lcs environment entry.
        The name of the registration is determined by the Name "UAT".
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Get-D365LcsAssetValidationStatus
        
    .LINK
        Get-D365LcsDeploymentStatus
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Tags: Servicing, Broadcast, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Anderson Joyle (@AndersonJoyle)
#>

function Import-D365ExternalUser {
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
        try {
            $provider = 'https://sts.windows.net/' + $Email.split('@')[1]

            Import-AadUserIntoD365FO $SqlCommand $Email $Name $Id $SID $Company $provider $provider

            if (Test-PSFFunctionInterrupt) { return }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally {
            if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
                $sqlCommand.Connection.Close()
            }
            $sqlCommand.Dispose()
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