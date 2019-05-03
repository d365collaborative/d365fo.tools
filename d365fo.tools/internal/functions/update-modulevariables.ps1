
<#
    .SYNOPSIS
        Short description
        
    .DESCRIPTION
        Long description
        
    .EXAMPLE
        An example
        
    .NOTES
        General notes
#>

function Update-ModuleVariables {
    [CmdletBinding()]
    [OutputType()]
    param ( )

    $Script:SqlPackage = Get-PSFConfigValue -FullName "d365fo.tools.path.sqlpackage"

    $Script:AADOAuthEndpoint = Get-PSFConfigValue -FullName "d365fo.tools.azure.common.oauth.token"
}