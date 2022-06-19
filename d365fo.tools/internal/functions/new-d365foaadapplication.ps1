
<#
    .SYNOPSIS
        Creates a new Azure Active Directory (AAD) application
        
    .DESCRIPTION
        Creates a new Azure Active Directory (AAD) application in a Dynamics 365 for Finance & Operations instance
        
    .PARAMETER sqlCommand
        The SQL Command object that should be used when creating the new application
        
    .PARAMETER Name
        The name that the imported application should have inside the D365FO environment
        
    .PARAMETER UserId
        The id of the user linked to the application inside the D365FO environment
        
    .PARAMETER ClientId
        The Client ID that the imported application should use inside the D365FO environment
        
    .EXAMPLE
        PS C:\> $SqlCommand = Get-SqlCommand -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
        PS C:\> New-D365FOAadApplication -SqlCommand $SqlCommand -Name "Application1" -UserId "admin" -ClientId "aef2e67c-64a3-4c72-9294-d288c5bf503d"
        This will get a SqlCommand object that will connect to the localhost server and the AXDB database, with the sql credential "User123".
        The SqlCommand object is passed to the New-D365FOAadApplication along with all the necessary details for importing Application1 as an application linked to user admin into the D365FO environment.
        
    .NOTES
        Author: Gert Van Der Heyden (@gertvdheyden)
        
#>
function New-D365FOAadApplication {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    Param (
        [System.Data.SqlClient.SqlCommand] $SqlCommand,

        [string] $Name,

        [string] $UserId,

        [string] $ClientId
    )
    
    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\Add-AadApplicationIntoD365FO.sql") -join [Environment]::NewLine

    Write-PSFMessage -Level Verbose -Message "Adding Application : $Name,$UserId,$ClientId"
    
    $null = $sqlCommand.Parameters.Add("@Name", $Name)
    $null = $sqlCommand.Parameters.Add("@UserId", $UserId)
    $null = $sqlCommand.Parameters.Add("@ClientId", $ClientId)

    Write-PSFMessage -Level Verbose -Message "Creating the application in database"

    Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

    $null = $sqlCommand.ExecuteNonQuery()
    
    Write-PSFMessage -Level Verbose -Message "Added application"
}