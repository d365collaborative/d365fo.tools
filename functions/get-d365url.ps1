<#
.SYNOPSIS
Get the url for accessing the instance

.DESCRIPTION
Get the complete URL for accessing the Dynamics 365 Finance & Operations instance running on this machine

.EXAMPLE
Get-D365Url

This will get the correct URL to access the environment

.NOTES
The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations. 
The call to the dll file gets all registered URL for the environment.
#>
function Get-D365Url {
    [CmdletBinding()]
    param ()
    
    [PSCustomObject]@{
        Url = "https://$($(Get-D365EnvironmentSettings).Infrastructure.FullyQualifiedDomainName)"
    }
}