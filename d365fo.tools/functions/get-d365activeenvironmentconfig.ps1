
<#
    .SYNOPSIS
        Get active environment configuration
        
    .DESCRIPTION
        Get active environment configuration object from the configuration store
        
    .EXAMPLE
        PS C:\> Get-D365ActiveEnvironmentConfig
        
        This will get the active environment configuration
        
    .NOTES
        You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365ActiveEnvironmentConfig {
    [CmdletBinding()]
    param ()

    (Get-PSFConfigValue -FullName "d365fo.tools.active.environment")
}