
<#
    .SYNOPSIS
        Register Azure Storage Configurations
        
    .DESCRIPTION
        Register all Azure Storage Configurations
        
    .PARAMETER ConfigStorageLocation
        Parameter used to instruct where to store the configuration objects
        
        The default value is "User" and this will store all configuration for the active user
        
        Valid options are:
        "User"
        "System"
        
        "System" will store the configuration as default for all users, so they can access the configuration objects
        
    .EXAMPLE
        PS C:\> Register-D365AzureStorageConfig -ConfigStorageLocation "System"
        
        This will store all Azure Storage Configurations as defaults for all users on the machine.
        
    .NOTES
        Tags: Configuration, Azure, Storage
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Register-D365AzureStorageConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [ValidateSet('User', 'System')]
        [string] $ConfigStorageLocation = "User"
    )

    $configScope = Test-ConfigStorageLocation -ConfigStorageLocation $ConfigStorageLocation
    
    Register-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" -Scope $configScope
}