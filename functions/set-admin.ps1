<#
.SYNOPSIS
Powershell implementation of the AdminProvising Tool

.DESCRIPTION
AdminProvising tool embeded in powershell using the AdminProvising tool from D365FO

.PARAMETER AdminSignInName
Email for the Admin

.PARAMETER DatabaseServer
Alternative SQL Database server, Default is the one provided by the DataAccess object

.PARAMETER DatabaseName
Alternative SQL Database, Default is the one provieded by the DataAccess object

.PARAMETER SqlUser
Alternative SQL user, Default is the one provieded by the DataAccess object

.PARAMETER SqlPwd
Alternative SQL user password, Default is the one provieded by the DataAccess object

.EXAMPLE
Set-Admin "user@mycompany.com"

.NOTES
#>
function Set-Admin
{

    param (
    [Parameter(Mandatory=$true, Position=1)]
    [String]$AdminSignInName,

    [Parameter(Mandatory=$false, Position=2)]
    [string]$DatabaseServer = $Script:DatabaseServer,

    [Parameter(Mandatory=$false, Position=3)]
    [string]$DatabaseName = $Script:DatabaseName,

    [Parameter(Mandatory=$false, Position=4)]
    [string]$SqlUser = $Script:DatabaseUserName,

    [Parameter(Mandatory=$false, Position=5)]
    [string]$SqlPwd = $Script:DatabaseUserPassword
    
    )

    Test-ElevatedRunTime

    Set-AdminUser $AdminSignInName $DatabaseServer $DatabaseName $SqlUser $SqlPwd
}