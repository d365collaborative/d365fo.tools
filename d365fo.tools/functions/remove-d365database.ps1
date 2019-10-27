
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
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
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
        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [switch] $EnableException
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
        $messageString = "Something went wrong while <c='em'>removing the Database."
        Write-PSFMessage -Level Host -Message $messageString
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -StepsUpward 1
        return
    }
}