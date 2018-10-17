
<#
    .SYNOPSIS
        Removes a Database
        
    .DESCRIPTION
        Removes a Database
        
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
        
    .EXAMPLE
        PS C:\> Remove-D365Database -DatabaseName "ExportClone"
        
        This will remove the "ExportClone" from the default SQL Server instance that is registered on the machine.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>

function Remove-D365Database {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$SqlPwd = $Script:DatabaseUserPassword
    )

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters
    
    $null = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')

    $srv = new-object Microsoft.SqlServer.Management.Smo.Server("$DatabaseServer")

    if (-not $UseTrustedConnection) {
        $srv.ConnectionContext.set_LoginSecure($false)
        $srv.ConnectionContext.set_Login("$SqlUser")
        $srv.ConnectionContext.set_Password("$SqlPwd")
    }
    
    try {
        $db = $srv.Databases["$DatabaseName"]

        if (!$db) {
            Write-PSFMessage -Level Verbose -Message "Database $DatabaseName not found. Nothing to remove."
            return
        }

        if ($srv.ServerType -ne "SqlAzureDatabase") {
            $srv.KillAllProcesses("$DatabaseName")
        }
    
        Write-PSFMessage -Level Verbose -Message "Dropping $DatabaseName" -Target $DatabaseName
    
        $db.Drop()
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while removing the DB" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}