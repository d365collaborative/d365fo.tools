<#
.SYNOPSIS
Get D365FO.Tools configuration

.DESCRIPTION
Get all the configuration objects on the system

.PARAMETER Name
The name of the environment you are looking for

Default value is "*" to display all environments

.EXAMPLE
Get-D365EnvironmentConfig

This will show all environment configurations

.NOTES

You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.

#>
function Get-D365EnvironmentConfig {
    [CmdletBinding()]
    param (
        [string] $Name = "*"

    )
    if ((Get-PSFConfig -FullName "d365fo.tools*").Count -eq 0) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>configuration objects</c> on the machine. Please make sure that you ran <c='em'>Initialize-D365Config</c> first."
        Stop-PSFFunction -Message "Stopping because unable to locate configuration objects."
        return
    }
    else {
        $Environments = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.environments")
        
        foreach ($item in $Environments.Keys) {
            if ($item -NotLike $Name) { continue }
            $temp = [ordered]@{Name = $item}
            $temp += $Environments[$item]
            [PSCustomObject]$temp
        } 
    }
}