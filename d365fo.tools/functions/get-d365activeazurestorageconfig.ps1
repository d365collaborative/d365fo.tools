
<#
    .SYNOPSIS
        Get active Azure Storage Account configuration
        
    .DESCRIPTION
        Get active Azure Storage Account configuration object from the configuration store
        
    .PARAMETER OutputAsPsCustomObject
        Instruct the cmdlet to return a PsCustomObject object
        
    .EXAMPLE
        PS C:\> Get-D365ActiveAzureStorageConfig
        
        This will get the active Azure Storage configuration.
        
    .EXAMPLE
        PS C:\> Get-D365ActiveAzureStorageConfig -OutputAsPsCustomObject
        
        This will get the active Azure Storage configuration.
        The object will be output as a PsCustomObject, for you to utilize across your scripts.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, Container
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365ActiveAzureStorageConfig {
    [CmdletBinding()]
    param (
        [switch] $OutputAsPsCustomObject
    )

    $res = Get-PSFConfigValue -FullName "d365fo.tools.active.azure.storage.account"

    if ($OutputAsPsCustomObject) {
        [PSCustomObject]$res
    }
    else {
        $res
    }
}