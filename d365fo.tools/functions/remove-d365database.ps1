<#
.SYNOPSIS
Removes a Database

.DESCRIPTION
Removes a Database

.PARAMETER DatabaseServer
The server the database is on

.PARAMETER DatabaseName
Name of the database to remove

.PARAMETER SqlUser
The User with rights for dropping the database

.PARAMETER SqlPwd
Password for the SqlUser

.EXAMPLE
Remove-D365Database -DatabaseName "database_original"

.NOTES
General notes
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

    if (-not ($UseTrustedConnection)) {
        $srv.ConnectionContext.set_Login("$SqlUser")
        $srv.ConnectionContext.set_Password("$SqlPwd")
    }
    
    try {
        $db = $srv.Databases["$DatabaseName"]

        if ($srv.ServerType -ne "SqlAzureDatabase") {
            $srv.KillAllProcesses("$DatabaseName")
        }
    
        Write-Verbose "Dropping $DatabaseName"
    
        $db.Drop()        
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while removing the DB" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}