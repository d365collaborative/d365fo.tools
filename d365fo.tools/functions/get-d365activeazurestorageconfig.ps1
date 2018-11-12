
<#
    .SYNOPSIS
        Get active Azure Storage Account configuration
        
    .DESCRIPTION
        Get active Azure Storage Account configuration object from the configuration store
        
    .EXAMPLE
        PS C:\> Get-D365ActiveAzureStorageConfig
        
        This will get the active Azure Storage configuration
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365ActiveAzureStorageConfig {
    [CmdletBinding()]
    param ()

    Get-PSFConfigValue -FullName "d365fo.tools.active.azure.storage.account"
}