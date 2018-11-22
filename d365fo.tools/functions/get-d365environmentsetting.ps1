
<#
    .SYNOPSIS
        Get the D365FO environment settings
        
    .DESCRIPTION
        Gets all settings the Dynamics 365 for Finance & Operations environment uses.
        
    .EXAMPLE
        PS C:\> Get-D365EnvironmentSetting
        
        This will get all details available for the environment
        
    .EXAMPLE
        PS C:\> Get-D365EnvironmentSetting | Format-Custom -Property *
        
        This will get all details available for the environment and format it to show all details in a long custom object.
        
    .NOTES
        Tags: Environment, Configuration, WebConfig, Web.Config, Decryption
        
        Author: Rasmus Andersen (@ITRasmus)
        
        The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations.
        The call to the dll file gets all relevant details for the installation.
#>
function Get-D365EnvironmentSettings {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param ()

    Get-ApplicationEnvironment
}