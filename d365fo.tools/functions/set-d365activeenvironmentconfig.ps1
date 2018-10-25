
<#
    .SYNOPSIS
        Set the active environment configuration
        
    .DESCRIPTION
        Updates the current active environment configuration with a new one
        
    .PARAMETER Name
        The name the environment configuration you want to load into the active environment configuration
        
    .PARAMETER Temporary
        Switch to instruct the cmdlet to only temporarily override the persisted settings in the configuration storage
        
    .EXAMPLE
        PS C:\> Set-D365ActiveEnvironmentConfig -Name "UAT"
        
        Will scan the list of environment configurations and select the one that matches the supplied name. This gets imported into the active environment configuration.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.
        
        You will have to run the Add-D365EnvironmentConfig cmdlet at least once, before this will be capable of working.
        
#>
function Set-D365ActiveEnvironmentConfig {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [string] $Name,
        
        [switch] $Temporary
    )

    if ((Get-PSFConfig -FullName "d365fo.tools*").Count -eq 0) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>configuration objects</c> on the machine. Please make sure that you ran <c='em'>Initialize-D365Config</c> first."
        Stop-PSFFunction -Message "Stopping because unable to locate configuration objects."
        return
    }
    else {
        $environmentConfigs = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.environments")

        if (($null -eq $environmentConfigs) -or ($environmentConfigs.ContainsKey("Dummy"))) {$environmentConfigs = @{}
        }
        
        if (-not ($environmentConfigs.ContainsKey($Name))) {
            Write-PSFMessage -Level Host -Message "An environment with that name <c='em'>doesn't exists</c>."
            Stop-PSFFunction -Message "Stopping because an environment with that name doesn't exists."
            return
        }
        else {
            $environmentDetails = $environmentConfigs[$Name]

            Set-PSFConfig -FullName "d365fo.tools.active.environment" -Value $environmentDetails
            if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.active.environment" }

            $Script:Url = $environmentDetails.URL
            $Script:DatabaseUserName = $environmentDetails.SqlUser
            $Script:DatabaseUserPassword = $environmentDetails.SqlPwd
            $Script:Company = $environmentDetails.Company
        }
    }
}