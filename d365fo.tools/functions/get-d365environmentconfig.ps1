
<#
    .SYNOPSIS
        Get environment configs
        
    .DESCRIPTION
        Get all environment configuration objects from the configuration store
        
    .PARAMETER Name
        The name of the environment you are looking for
        
        Default value is "*" to display all environment configs
        
    .EXAMPLE
        PS C:\> Get-D365EnvironmentConfig
        
        This will show all environment configs
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, Tfs, Vsts, Sql, SqlUser, SqlPwd
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365EnvironmentConfig {
    [CmdletBinding()]
    param (
        [string] $Name = "*"

    )
    
    $Environments = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.environments")
        
    foreach ($item in $Environments.Keys) {
        if ($item -NotLike $Name) { continue }
        $temp = [ordered]@{Name = $item}
        $temp += $Environments[$item]
        [PSCustomObject]$temp
    }
}