
<#
    .SYNOPSIS
        Get active environment configuration
        
    .DESCRIPTION
        Get active environment configuration object from the configuration store
        
    .EXAMPLE
        PS C:\> Get-D365ActiveEnvironmentConfig
        
        This will get the active environment configuration
        
    .EXAMPLE
        PS C:\> $params = @{}
        PS C:\> $params.SqlUser = (Get-D365ActiveEnvironmentConfig).SqlUser
        PS C:\> $params.SqlPwd = (Get-D365ActiveEnvironmentConfig).SqlPwd
        
        This gives you a hashtable with the SqlUser and SqlPwd values from the active environment.
        This enables you to use the $params as splatting for other cmdlets.
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, Tfs, Vsts, Sql, SqlUser, SqlPwd
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365ActiveEnvironmentConfig {
    [CmdletBinding()]
    param ()

    (Get-PSFConfigValue -FullName "d365fo.tools.active.environment")
}