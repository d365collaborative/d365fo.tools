
<#
    .SYNOPSIS
        Get the network domain from the e-mail
        
    .DESCRIPTION
        Get the network domain provider (Azure) for the e-mail / user
        
    .PARAMETER Email
        The e-mail that you want to retrieve the provider for
        
    .EXAMPLE
        PS C:\> Get-NetworkDomain -Email "Claire@contoso.com"
        
        This will return the provider registered with the "Claire@contoso.com" e-mail address.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-NetworkDomain {
    [CmdletBinding()]
    [OutputType('System.String')]
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Email
    )

    $tenant = Get-TenantFromEmail $Email
    $provider = Get-InstanceIdentityProvider
    $canonicalIdentityProvider = Get-CanonicalIdentityProvider

    if ($Provider.ToLower().Contains($Tenant.ToLower()) -eq $True) {
        $canonicalIdentityProvider
    }
    else {
        "$canonicalIdentityProvider$Tenant"
    }
}