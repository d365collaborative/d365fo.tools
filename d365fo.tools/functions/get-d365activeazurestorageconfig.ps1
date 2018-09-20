<#
.SYNOPSIS
Get active Azure Storage Account configuration

.DESCRIPTION
Get active Azure Storage Account configuration object from the configuration store

.EXAMPLE
Get-D365ActiveAzureStorageConfig

This will get the active Azure Storage configuration

.NOTES

You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.

#>
function Get-D365ActiveAzureStorageConfig {
    [CmdletBinding()]
    param ()

    if ((Get-PSFConfig -FullName "d365fo.tools*").Count -eq 0) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>configuration objects</c> on the machine. Please make sure that you ran <c='em'>Initialize-D365Config</c> first."
        Stop-PSFFunction -Message "Stopping because unable to locate configuration objects."
        return
    }
    else {
        (Get-PSFConfigValue -FullName "d365fo.tools.active.azure.storage.account")
    }
} 