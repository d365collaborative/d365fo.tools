<#
.SYNOPSIS
Get Azure Storage Account configs

.DESCRIPTION
Get all Azure Storage Account configuration objects from the configuration store

.PARAMETER Name
The name of the Azure Storage Account you are looking for

Default value is "*" to display all Azure Storage Account configs

.EXAMPLE
Get-D365AzureStorageConfig

This will show all Azure Storage Account configs

.NOTES
You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.

Author: Mötz Jensen (@Splaxi)

#>
function Get-D365AzureStorageConfig {
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
        $Environments = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.azure.storage.accounts")
        
        foreach ($item in $Environments.Keys) {
            if ($item -NotLike $Name) { continue }
            $temp = [ordered]@{Name = $item}
            $temp += $Environments[$item]
            [PSCustomObject]$temp
        }
    }
}