<#
.SYNOPSIS
Set the active Azure Storage Account configuration

.DESCRIPTION
Updates the current active Azure Storage Account configuration with a new one

.PARAMETER Name
The name the Azure Storage Account configuration you want to load into the 
active Azure Storage Account configuration

.EXAMPLE
Set-D365ActiveAzureStorageConfig -Name "UAT-Exports"

Will scan the list of Azure Storage Account configurations and select the one that matches the 
supplied name. This gets imported into the active Azure Storage Account configuration.

.NOTES

You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.

You will have to run the Add-D365AzureStorageConfig cmdlet at least once, before this will be capable of working.
#>
function Set-D365ActiveAzureStorageConfig {
    [CmdletBinding()]
    param (
        [string] $Name
    )

    if ((Get-PSFConfig -FullName "d365fo.tools*").Count -eq 0) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>configuration objects</c> on the machine. Please make sure that you ran <c='em'>Initialize-D365Config</c> first."
        Stop-PSFFunction -Message "Stopping because unable to locate configuration objects."
        return
    }
    else {
        $Accounts = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.azure.storage.accounts")

        if($null -eq $Accounts) {$Accounts = @{}}

        if (!($Accounts.ContainsKey($Name))) {
            Write-PSFMessage -Level Host -Message "An Azure Storage Account with that name <c='em'>doesn't exists</c>."
            Stop-PSFFunction -Message "Stopping because an Azure Storage Account with that name doesn't exists."
            return
        }
        else {
            $Details = $Accounts[$Name]

            Set-PSFConfig -FullName "d365fo.tools.active.azure.storage.account" -Value $Details   
            Get-PSFConfig -FullName "d365fo.tools.active.azure.storage.account" | Register-PSFConfig

            Write-PSFMessage -Level Host -Message "Please <c='em'>restart</c> the powershell session / console. This change affects core functionality that <c='em'>requires</c> the module to be <c='em'>reloaded</c>."
        }
    }
}