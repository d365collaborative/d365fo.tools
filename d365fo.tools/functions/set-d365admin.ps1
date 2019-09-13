
<#
    .SYNOPSIS
        Powershell implementation of the AdminProvisioning tool
        
    .DESCRIPTION
        Cmdlet using the AdminProvisioning tool from D365FO
        
    .PARAMETER AdminSignInName
        Email for the Admin
        
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
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Set-D365Admin "claire@contoso.com"
        
        This will provision claire@contoso.com as administrator for the environment
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        Author: Mark Furrer (@devax_mf)
#>
function Set-D365Admin {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        
        [Parameter(Mandatory = $true, Position = 1)]
        [Alias('Email')]
        [String]$AdminSignInName,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 5)]
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [switch] $EnableException

    )

    if (-not ($script:IsAdminRuntime)) {
        Write-PSFMessage -Level Host -Message "The cmdlet needs <c='em'>administrator permission</c> (Run As Administrator) to be able to update the configuration. Please start an <c='em'>elevated</c> session and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because the function is not run elevated"
        return
    }

    Set-AdminUser $AdminSignInName $DatabaseServer $DatabaseName $SqlUser $SqlPwd
}