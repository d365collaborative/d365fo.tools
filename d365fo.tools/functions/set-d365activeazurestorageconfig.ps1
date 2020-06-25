
<#
    .SYNOPSIS
        Set the active Azure Storage Account configuration
        
    .DESCRIPTION
        Updates the current active Azure Storage Account configuration with a new one
        
    .PARAMETER Name
        The name the Azure Storage Account configuration you want to load into the active Azure Storage Account configuration
        
    .PARAMETER ConfigStorageLocation
        Parameter used to instruct where to store the configuration objects
        
        The default value is "User" and this will store all configuration for the active user
        
        Valid options are:
        "User"
        "System"
        
        "System" will store the configuration so all users can access the configuration objects
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily override the persisted settings in the configuration storage
        
    .EXAMPLE
        PS C:\> Set-D365ActiveAzureStorageConfig -Name "UAT-Exports"
        
        This will import the "UAT-Exports" set from the Azure Storage Account configurations.
        It will update the active Azure Storage Account configuration.
        
    .EXAMPLE
        PS C:\> Set-D365ActiveAzureStorageConfig -Name "UAT-Exports" -ConfigStorageLocation "System"
        
        This will import the "UAT-Exports" set from the Azure Storage Account configurations.
        It will update the active Azure Storage Account configuration.
        The data will be stored in the system wide configuration storage, which makes it accessible from all users.
        
    .EXAMPLE
        PS C:\> Set-D365ActiveAzureStorageConfig -Name "UAT-Exports" -Temporary
        
        This will import the "UAT-Exports" set from the Azure Storage Account configurations.
        It will update the active Azure Storage Account configuration.
        The update will only last for the rest of this PowerShell console session.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.
        
        You will have to run the Add-D365AzureStorageConfig cmdlet at least once, before this will be capable of working.
        
#>
function Set-D365ActiveAzureStorageConfig {
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

    $azureStorageConfigs = [hashtable] (Get-PSFConfigValue -FullName "d365fo.tools.azure.storage.accounts")

    if (-not ($azureStorageConfigs.ContainsKey($Name))) {
        Write-PSFMessage -Level Host -Message "An Azure Storage Account with that name <c='em'>doesn't exists</c>."
        Stop-PSFFunction -Message "Stopping because an Azure Storage Account with that name doesn't exists."
        return
    }
    else {
        $azureDetails = $azureStorageConfigs[$Name]

        Set-PSFConfig -FullName "d365fo.tools.active.azure.storage.account" -Value $azureDetails
        if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.active.azure.storage.account"  -Scope $configScope }
        
        Update-AzureStorageVariables
    }
}