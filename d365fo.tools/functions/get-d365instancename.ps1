
<#
    .SYNOPSIS
        Gets the instance name
        
    .DESCRIPTION
        Get the instance name that is registered in the environment
        
    .EXAMPLE
        PS C:\> Get-D365InstanceName
        
        This will get the service name that the environment has configured
        
    .NOTES
        Tags: Instance, Servicing
        
        Author: Rasmus Andersen (@ITRasmus)
        
        The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations.
        The call to the dll file gets HostedServiceName that is registered in the environment.
        
#>
function Get-D365InstanceName {
    [CmdletBinding()]
    param ()

    [PSCustomObject]@{
        InstanceName = "$($(Get-D365EnvironmentSettings).Infrastructure.HostedServiceName)"
    }
}