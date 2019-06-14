
<#
    .SYNOPSIS
        Update the module variables based on the PSF Configuration store
        
    .DESCRIPTION
        Will read the current PSF Configuration store and create local module variables
        
    .EXAMPLE
        PS C:\> Update-PsfConfigVariables
        
        This will read all relevant PSF Configuration values and create matching module variables.
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
#>

function Update-PsfConfigVariables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

    [CmdletBinding()]
    [OutputType()]
    param ()

    foreach ($config in Get-PSFConfig -FullName "d365fo.tools.path.*") {
        $item = $config.FullName.Replace("d365fo.tools.path.", "")
        $name = (Get-Culture).TextInfo.ToTitleCase($item) + "Path"
        
        Set-Variable -Name $name -Value $config.Value -Scope Script
    }
}