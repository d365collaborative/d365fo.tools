<#
.SYNOPSIS
Initialize D365FO.Tools configuration

.DESCRIPTION
Creates all the configuration objects on the system

.PARAMETER Clear
Switch to instruct the cmdlet to clear the already stored configuration

.EXAMPLE
Initialize-D365Config

Will create all the standard D365FO.Tools configuration objects

.NOTES
#>
function Initialize-D365Config {
    [CmdletBinding()]
    param (
        [switch] $Clear
    )
    
    if ($Clear.IsPresent -or ((Get-PSFConfig -FullName "d365fo.tools*").Count -eq 0)) {
        Set-PSFConfig -FullName "d365fo.tools.workstation.mode" -Value $false -Description "Setting to assist the module to grab the URL from configuration rather from the non existing dll files." 
        Set-PSFConfig -FullName "d365fo.tools.active.environment" -Value @{Dummy = @{Dummy = ""}} -Description "Object that stores the environment details that should be used during the module." 
        Set-PSFConfig -FullName "d365fo.tools.environments" -Value @{Dummy = @{Dummy = ""}} -Description "Object that stores different environments and their details." 
        Set-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" -Value @{Dummy = @{Dummy = ""}} -Description "Object that stores different Azure Storage Account and their details." 
        Set-PSFConfig -FullName "d365fo.tools.active.azure.storage.account" -Value @{Dummy = @{Dummy = ""}} -Description "Object that stores the Azure Storage Account details that should be used during the module." 
        Set-PSFConfig -FullName "d365fo.tools.active.logic.app" -Value @{Dummy = @{Dummy = ""}} -Description "Object that stores the Azure Logic App details that should be used during the module." 

        Get-PSFConfig -FullName "d365fo.tools*" | Register-PSFConfig
    }
}