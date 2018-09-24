<#
.SYNOPSIS
Get the D365FO environment settings

.DESCRIPTION
Gets all settings the Dynamics 365 for Finance & Operations environment uses.

.EXAMPLE
Get-D365EnvironmentSettings

This will get all details available for the environment

.EXAMPLE
Get-D365EnvironmentSettings | Format-Custom -Property *

This will get all details available for the environment and format it to show all details in a long 
custom object.

.NOTES
The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations. 
The call to the dll file gets all relevant details for the installation.
#>
function Get-D365EnvironmentSettings {
    [CmdletBinding()]
    param ()

    Get-ApplicationEnvironment
}
