
<#
    .SYNOPSIS
        Update the Azure Storage config variables
        
    .DESCRIPTION
        Update the active Azure Storage config variables that the module will use as default values
        
    .EXAMPLE
        PS C:\> Update-AzureStorageVariables
        
        This will update the Azure Storage variables.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Update-AzureStorageVariables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType()]
    param ( )
    
    $hashParameters = Get-D365ActiveAzureStorageConfig

    foreach ($item in $hashParameters.Keys) {
            
        $name = "AzureStorage" + (Get-Culture).TextInfo.ToTitleCase($item)
        
        Write-PSFMessage -Level Verbose -Message "$name - $($hashParameters[$item])" -Target $hashParameters[$item]
        Set-Variable -Name $name -Value $hashParameters[$item] -Scope Script
    }
}