<#
.SYNOPSIS
Cmdlet used to get authentication details about a user

.DESCRIPTION
The cmdlet will take the e-mail parameter and use it to lookup all the needed details for configuring authentication against Dynamics 365 Finance & Operations

.PARAMETER Email
The e-mail address / login name of the user that the cmdlet must gather details about

.EXAMPLE
Get-D365UserAuthenticationDetail 

.NOTES
General notes
#>
function Get-D365UserAuthenticationDetail {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [string]$Email
    ) 

    $instanceProvider = Get-InstanceIdentityProvider

    $identityProvider = Get-CanonicalIdentityProvider
    $tenant = Get-TenantFromEmail $Email
    $networkDomain = get-NetworkDomain $Email

    if ($instanceProvider.ToLower().Contains($tenant.ToLower()) -ne $True) {
        $identityProvider = Get-IdentityProvider $Email
    }
    $SID = Get-UserSIDFromAad $Email $identityProvider


    @{"SID"                = $SID 
        "NetworkDomain"    = $networkDomain  
        "IdentityProvider" = $identityProvider
        "InstanceProvider" = $instanceProvider
    }
}