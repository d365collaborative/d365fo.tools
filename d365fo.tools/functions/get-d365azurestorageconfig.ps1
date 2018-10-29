
<#
    .SYNOPSIS
        Get Azure Storage Account configs
        
    .DESCRIPTION
        Get all Azure Storage Account configuration objects from the configuration store
        
    .PARAMETER Name
        The name of the Azure Storage Account you are looking for
        
        Default value is "*" to display all Azure Storage Account configs
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageConfig
        
        This will show all Azure Storage Account configs
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365AzureStorageConfig {
    [CmdletBinding()]
    param (
        [string] $Name = "*"

    )
    
    $Environments = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.azure.storage.accounts")
        
    foreach ($item in $Environments.Keys) {
        if ($item -NotLike $Name) { continue }
        $temp = [ordered]@{Name = $item}
        $temp += $Environments[$item]
        [PSCustomObject]$temp
    }
}