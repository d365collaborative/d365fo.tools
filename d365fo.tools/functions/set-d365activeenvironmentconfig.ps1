
<#
    .SYNOPSIS
        Set the active environment configuration
        
    .DESCRIPTION
        Updates the current active environment configuration with a new one
        
    .PARAMETER Name
        The name the environment configuration you want to load into the active environment configuration
        
    .PARAMETER ConfigStorageLocation
        Parameter used to instruct where to store the configuration objects
        
        The default value is "User" and this will store all configuration for the active user
        
        Valid options are:
        "User"
        "System"
        
        "System" will store the configuration so all users can access the configuration objects
        
    .PARAMETER Temporary
        Switch to instruct the cmdlet to only temporarily override the persisted settings in the configuration storage
        
    .EXAMPLE
        PS C:\> Set-D365ActiveEnvironmentConfig -Name "UAT"
        
        This will import the "UAT-Exports" set from the Environment configurations.
        It will update the active Environment Configuration.
        
    .EXAMPLE
        PS C:\> Set-D365ActiveEnvironmentConfig -Name "UAT" -ConfigStorageLocation "System"
        
        This will import the "UAT-Exports" set from the Environment configurations.
        It will update the active Environment Configuration.
        The data will be stored in the system wide configuration storage, which makes it accessible from all users.
        
    .EXAMPLE
        PS C:\> Set-D365ActiveEnvironmentConfig -Name "UAT" -Temporary
        
        This will import the "UAT-Exports" set from the Environment configurations.
        It will update the active Environment Configuration.
        The update will only last for the rest of this PowerShell console session.
        
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

        [ValidateSet('User', 'System')]
        [string] $ConfigStorageLocation = "User",
        
        [switch] $Temporary
    )

    $configScope = Test-ConfigStorageLocation -ConfigStorageLocation $ConfigStorageLocation

    if (Test-PSFFunctionInterrupt) { return }

    $environmentConfigs = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.environments")
        
    if (-not ($environmentConfigs.ContainsKey($Name))) {
        Write-PSFMessage -Level Host -Message "An environment with that name <c='em'>doesn't exists</c>."
        Stop-PSFFunction -Message "Stopping because an environment with that name doesn't exists."
        return
    }
    else {
        $environmentDetails = $environmentConfigs[$Name]

        Set-PSFConfig -FullName "d365fo.tools.active.environment" -Value $environmentDetails
        if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.active.environment" -Scope $configScope }

        $Script:Url = $environmentDetails.URL
        $Script:DatabaseUserName = $environmentDetails.SqlUser
        $Script:DatabaseUserPassword = $environmentDetails.SqlPwd
        $Script:Company = $environmentDetails.Company

        $Script:TfsUri = $environmentDetails.TfsUri
    }
}