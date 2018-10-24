
<#
    .SYNOPSIS
        Powershell implementation of the AdminProvisioning tool
        
    .DESCRIPTION
        Cmdlet using the AdminProvisioning tool from D365FO
        
    .PARAMETER AdminSignInName
        Email for the Admin
        
    .PARAMETER DatabaseServer
        Alternative SQL Database server, Default is the one provided by the DataAccess object
        
    .PARAMETER DatabaseName
        Alternative SQL Database, Default is the one provided by the DataAccess object
        
    .PARAMETER SqlUser
        Alternative SQL user, Default is the one provided by the DataAccess object
        
    .PARAMETER SqlPwd
        Alternative SQL user password, Default is the one provided by the DataAccess object
        
    .EXAMPLE
        PS C:\> Set-D365Admin "claire@contoso.com"
        
        This will provision claire@contoso.com as administrator for the environment
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
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
        [string]$SqlPwd = $Script:DatabaseUserPassword

    )

    if (-not ($script:IsAdminRuntime)) {
        Write-PSFMessage -Level Host -Message "The cmdlet needs <c='em'>administrator permission</c> (Run As Administrator) to be able to update the configuration. Please start an <c='em'>elevated</c> session and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because the function is not run elevated"
        return
    }

    Set-AdminUser $AdminSignInName $DatabaseServer $DatabaseName $SqlUser $SqlPwd
}