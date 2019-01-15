
<#
    .SYNOPSIS
        Get the url for accessing the instance
        
    .DESCRIPTION
        Get the complete URL for accessing the Dynamics 365 Finance & Operations instance running on this machine
        
    .PARAMETER Force
        Switch to instruct the cmdlet to retrieve the name from the system files
        instead of the name stored in memory after loading this module.
        
    .EXAMPLE
        PS C:\> Get-D365Url
        
        This will get the correct URL to access the environment
        
    .NOTES
        Tags: URL, URI, Servicing
        
        Author: Rasmus Andersen (@ITRasmus)
        
        The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations.
        The call to the dll file gets all registered URL for the environment.
        
#>
function Get-D365Url {
    [CmdletBinding()]
    param (
        [switch] $Force
    )
    
    if ($Force) {
        $Url = "https://$($(Get-D365EnvironmentSettings).Infrastructure.FullyQualifiedDomainName)"
    }
    else {
        $Url = $Script:Url
        
    }
    [PSCustomObject]@{
        Url = $Url
    }
}