
<#
    .SYNOPSIS
        Get the tenant from e-mail address
        
    .DESCRIPTION
        Get the tenant (domain) from an e-mail address
        
    .PARAMETER Email
        The e-mail address you want to get the tenant from
        
    .EXAMPLE
        PS C:\> Get-TenantFromEmail -Email "Claire@contoso.com"
        
        This will return the tenant (domain) from the "Claire@contoso.com" e-mail address.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-TenantFromEmail {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [string] $email
    )

    $email.Substring($email.LastIndexOf('@') + 1).Trim();
}