
<#
    .SYNOPSIS
        Get Azure Storage Account configs
        
    .DESCRIPTION
        Get all Azure Storage Account configuration objects from the configuration store
        
    .PARAMETER Name
        The name of the Azure Storage Account you are looking for
        
        Default value is "*" to display all Azure Storage Account configs
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hastable object
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageConfig
        
        This will show all Azure Storage Account configs
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageConfig -OutputAsHashtable
        
        This will show all Azure Storage Account configs.
        Every object will be output as a hashtable, for you to utilize as parameters for other cmdlets.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, Container
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365AzureStorageConfig {
    [CmdletBinding()]
    param (
        [string] $Name = "*",

        [switch] $OutputAsHashtable
    )
    
    $StorageAccounts = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.azure.storage.accounts")
        
    foreach ($item in $StorageAccounts.Keys) {
        if ($item -NotLike $Name) { continue }
        $res = [ordered]@{Name = $item }
        $res += $StorageAccounts[$item]

        if ($OutputAsHashtable) {
            $res
        }
        else {
            [PSCustomObject]$res
        }
    }
}