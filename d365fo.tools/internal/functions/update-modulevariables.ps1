
<#
    .SYNOPSIS
        Update module variables
        
    .DESCRIPTION
        Loads configuration variables again, to make sure things are updated based on changed configuration
        
    .EXAMPLE
        PS C:\> Update-ModuleVariables
        
        This will update internal variables that the module is dependent on.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Update-ModuleVariables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType()]
    param ( )

    Update-PsfConfigVariables

    $Script:AADOAuthEndpoint = Get-PSFConfigValue -FullName "d365fo.tools.azure.common.oauth.token"
}