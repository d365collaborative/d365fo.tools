
<#
    .SYNOPSIS
        Update an Azure Active Directory (AAD) guest user
        
    .DESCRIPTION
        Update the identity provider, network domain and object id for an Azure Active Directory (AAD) guest user in a Dynamics 365 for Finance & Operations environment
        
    .PARAMETER SqlCommand
        The SQL Command object that should be used when updating the AAD guest user
        
    .PARAMETER Id
        The ID of the user that should be updated inside the D365FO environment
        
    .PARAMETER IdentityProvider
        The provider for the guest user to validated against
        
    .PARAMETER NetworkDomain
        The network domain of the guest user
        
    .PARAMETER ObjectId
        The Azure Active Directory object id for the guest user
        
    .EXAMPLE
        PS C:\> $SqlCommand = Get-SqlCommand -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
        PS C:\> Update-AadGuestUserInD365FO -SqlCommand $SqlCommand -Id "claire" -IdentityProvider "XYZ" -NetworkDomain "XYZ" -ObjectId "123XYZ"
        
        This will get a SqlCommand object that will connect to the localhost server and the AXDB database, with the sql credential "User123".
        The SqlCommand object is passed to the Update-AadGuestUserInD365FO along with the identity provider, network domain and object id for the guest user.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Update-AadGuestUserInD365FO {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [System.Data.SqlClient.SqlCommand] $SqlCommand,

        [string] $Id,

        [string] $IdentityProvider,

        [string] $NetworkDomain,

        [string] $ObjectId
    )

    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\update-aadguestuser.sql") -join [Environment]::NewLine

    Write-PSFMessage -Level Verbose -Message "Updating guest user : $Id,$IdentityProvider,$NetworkDomain,$ObjectId"

    $null = $sqlCommand.Parameters.Add("@id", $Id)
    $null = $sqlCommand.Parameters.Add("@networkDomain", $NetworkDomain)
    $null = $sqlCommand.Parameters.Add("@identityProvider", $IdentityProvider)
    $null = $sqlCommand.Parameters.Add("@objectId", $ObjectId)

    Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

    $null = $sqlCommand.ExecuteNonQuery()

    $SqlCommand.Parameters.Clear()
}