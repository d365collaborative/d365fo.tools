
<#
    .SYNOPSIS
        Get active environment configuration
        
    .DESCRIPTION
        Get active environment configuration object from the configuration store
        
    .EXAMPLE
        PS C:\> Get-D365ActiveEnvironmentConfig
        
        This will get the active environment configuration
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, Tfs, Vsts, Sql, SqlUser, SqlPwd
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365ActiveEnvironmentConfig {
    [CmdletBinding()]
    param ()

    (Get-PSFConfigValue -FullName "d365fo.tools.active.environment")
}