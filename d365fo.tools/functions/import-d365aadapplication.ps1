
<#
    .SYNOPSIS
        Used to import Aad applications into D365FO
        
    .DESCRIPTION
        Provides a method for importing a AAD application into D365FO.
        
    .PARAMETER Name
        The name that the imported application should have inside the D365FO environment
        
    .PARAMETER UserId
        The id of the user linked to the application inside the D365FO environment
        
    .PARAMETER ClientId
        The Client ID that the imported application should use inside the D365FO environment
        
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
        PS C:\> Import-D365AadApplication -Name "Application1" -UserId "admin" -ClientId "aef2e67c-64a3-4c72-9294-d288c5bf503d"
        
        Imports Application1 as an application linked to user admin into the D365FO environment.
        
    .NOTES
        Tags: User, Users, Security, Configuration, Permission, AAD, Azure Active Directory, Group, Groups
        
        Author: Gert Van Der Heyden (@gertvdheyden)
        
        At no circumstances can this cmdlet be used to import users into a PROD environment.
        
#>

function Import-D365AadApplication {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String] $Name,

        [Parameter(Mandatory = $true)]
        [string] $UserId,

        [Parameter(Mandatory = $true)]
        [string] $ClientId,

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword
    )

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    try {
        $sqlCommand.Connection.Open()

        Import-AadApplicationIntoD365FO $SqlCommand $Name $UserId $ClientId
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