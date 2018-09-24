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
Set-D365Admin "claire@contoso.com"

This will provision claire@contoso.com as administrator for the environment

.NOTES
#>
function Set-D365Admin {
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

    if (!$Script:IsAdminRuntime) {
        Write-Host "The cmdlet needs administrator permission (Run As Administrator) to be able to update the configuration. Please start an elevated session and run the cmdlet again." -ForegroundColor Yellow
        Write-Error "Elevated permissions needed. Please start an elevated session and run the cmdlet again." -ErrorAction Stop
    }

    Set-AdminUser $AdminSignInName $DatabaseServer $DatabaseName $SqlUser $SqlPwd
}