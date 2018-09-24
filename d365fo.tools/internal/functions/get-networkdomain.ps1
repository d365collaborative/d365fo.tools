<#
.SYNOPSIS
#

.DESCRIPTION
Functions for getting provider for importing a user into D365FO

.PARAMETER Email
Email used for the 

.PARAMETER AosServiceWebRootPath
Location of the D365 webroot folder

.EXAMPLE
Get-Provider -Email Email@Company.com

.NOTES
Only supports Azure Aad emails
#>
function Get-NetworkDomain
{
param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Email
    )
        $tenant  = Get-TenantFromEmail $Email
        $provider = Get-InstanceIdentityProvider
        $canonicalIdentityProvider = Get-CanonicalIdentityProvider

        if($Provider.ToLower().Contains($Tenant.ToLower()) -eq $True) {
            return $canonicalIdentityProvider
        }
        else {
            return "$canonicalIdentityProvider$Tenant"
        }

}