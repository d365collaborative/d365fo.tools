
<#
    .SYNOPSIS
        Cmdlet used to get authentication details about a user
        
    .DESCRIPTION
        The cmdlet will take the e-mail parameter and use it to lookup all the needed details for configuring authentication against Dynamics 365 Finance & Operations
        
    .PARAMETER Email
        The e-mail address / login name of the user that the cmdlet must gather details about
        
    .EXAMPLE
        PS C:\> Get-D365UserAuthenticationDetail -Email "Claire@contoso.com"
        
        This will get all the authentication details for the user account with the email address "Claire@contoso.com"
        
    .NOTES
        Tags: User, Users, Security, Configuration, Authentication
        
        Author : Rasmus Andersen (@ITRasmus)
        Author : Mötz Jensen (@splaxi)
        
#>
function Get-D365UserAuthenticationDetail {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $Email
    )

    process {
        $instanceProvider = Get-InstanceIdentityProvider

        [string]$identityProvider = Get-CanonicalIdentityProvider
    
        $networkDomain = Get-NetworkDomain $Email

        $instanceProviderName = $instanceProvider.TrimEnd('/')
        $instanceProviderName = $instanceProviderName.Substring($instanceProviderName.LastIndexOf('/') + 1)
        $instanceProviderIdentityProvider = Get-IdentityProvider "sample@$instanceProviderName"
        $emailIdentityProvider = Get-IdentityProvider $Email

        if ($instanceProviderIdentityProvider -ne $emailIdentityProvider) {
            $identityProvider = $emailIdentityProvider
        }

        $SID = Get-UserSIDFromAad $Email $identityProvider

        @{"SID"                = $SID
            "NetworkDomain"    = $networkDomain
            "IdentityProvider" = $identityProvider
            "InstanceProvider" = $instanceProvider
        }
    }
}