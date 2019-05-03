function Update-ModuleVariables {
    [CmdletBinding()]
    [OutputType()]
    param ( )

    $Script:SqlPackage = Get-PSFConfigValue -FullName "d365fo.tools.path.sqlpackage"
}