function Get-UserAuthenticationDetail ($Email) {

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