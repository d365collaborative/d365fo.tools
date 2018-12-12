
<#
    .SYNOPSIS
        Save hashtable with parameters
        
    .DESCRIPTION
        Saves the hashtable as a json string into the configuration store
        
        This cmdlet is only intended to be used for New-D365Bacpac and Import-D365Bacpac for Tier2 environments
        
    .PARAMETER InputObject
        The hashtable containing all the parameters you want to store
        
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
        PS C:\> $params = @{ SqlUser = "sqladmin"
        PS C:\> SqlPwd = "pass@word1"
        PS C:\> }
        PS C:\> Set-D365Tier2Params -InputObject $params
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Set-D365Tier2Params {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [HashTable] $InputObject,

        [ValidateSet('User', 'System')]
        [string] $ConfigStorageLocation = "User",
        
        [switch] $Temporary
    )

    if ($null -eq $($InputObject.Keys)) {
        Write-PSFMessage -Level Host -Message "The input object seems to be empty. Please ensure that the input object is a hashtable and it actually contains data."
        Stop-PSFFunction -Message "Stopping because the input object didn't contain data."
        return
    }
    
    $configScope = Test-ConfigStorageLocation -ConfigStorageLocation $ConfigStorageLocation

    $jsonString = ConvertTo-Json -InputObject $InputObject

    Write-PSFMessage -Level Verbose -Message "Converted hashtable to json string" -Target $jsonString

    Set-PSFConfig -FullName "d365fo.tools.tier2.bacpac.params" -Value $jsonString

    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.tier2.bacpac.params"  -Scope $configScope }
}