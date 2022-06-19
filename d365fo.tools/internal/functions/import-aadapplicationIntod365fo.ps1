
<#
    .SYNOPSIS
        Import an Azure Active Directory (AAD) application
        
    .DESCRIPTION
        Import an Azure Active Directory (AAD) application into a Dynamics 365 for Finance & Operations environment
        
    .PARAMETER SqlCommand
        The SQL Command object that should be used when importing the AAD application
        
    .PARAMETER Name
        The name that the imported application should have inside the D365FO environment
        
    .PARAMETER UserId
        The id of the user linked to the application inside the D365FO environment
        
    .PARAMETER ClientId
        The Client ID that the imported application should use inside the D365FO environment
        
    .EXAMPLE
        PS C:\> $SqlCommand = Get-SqlCommand -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
        PS C:\> Import-AadApplicationIntoD365FO -SqlCommand $SqlCommand -Name "Application1" -UserId "admin" -ClientId "aef2e67c-64a3-4c72-9294-d288c5bf503d"
        This will get a SqlCommand object that will connect to the localhost server and the AXDB database, with the sql credential "User123".
        The SqlCommand object is passed to the Import-AadApplicationIntoD365FO along with all the necessary details for importing Application1 as an application linked to user admin into the D365FO environment.
        
    .NOTES
        Author: Gert Van Der Heyden (@gertvdheyden)
        
#>
function Import-AadApplicationIntoD365FO {
    [CmdletBinding()]
    param
    (
        [System.Data.SqlClient.SqlCommand] $SqlCommand,

        [string] $Name,

        [string] $UserId,

        [string] $ClientId
    )

    Write-PSFMessage -Level Verbose -Message "Testing the userid $UserId"

    $idExists = Test-AadUserIdInD365FO $sqlCommand $UserId

    if ($idExists -eq $true) {

        New-D365FOAadApplication $sqlCommand $Name $UserId $ClientId

        Write-PSFMessage -Level Host -Message "Application $Name for user $UserId added to D365FO"
    }
    else {
        Write-PSFMessage -Level Host -Message "An User with ID = '$UserId' does not exists"
    }
}