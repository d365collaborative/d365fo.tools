<#
.SYNOPSIS
Get the url for accessing the instance

.DESCRIPTION
Get the complete URL for accessing the Dynamics 365 Finance & Operations instance running on this machine

.EXAMPLE
Get-D365Url

.NOTES
General notes
#>
function Get-D365Url {
    [CmdletBinding()]
    param ()
    
    "https://$($(Get-D365EnvironmentSettings).Infrastructure.FullyQualifiedDomainName)"
}