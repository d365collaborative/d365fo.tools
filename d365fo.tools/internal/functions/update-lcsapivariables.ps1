
<#
    .SYNOPSIS
        Update the LCS API config variables
        
    .DESCRIPTION
        Update the active LCS API config variables that the module will use as default values
        
    .EXAMPLE
        PS C:\> Update-LcsApiVariables
        
        This will update the LCS API variables.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Update-LcsApiVariables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType()]
    param ( )
    
    $hashParameters = Get-D365LcsApiConfig -OutputAsHashtable

    foreach ($item in $hashParameters.Keys) {
            
        $name = "LcsApi" + (Get-Culture).TextInfo.ToTitleCase($item)
        
        Write-PSFMessage -Level Verbose -Message "$name - $($hashParameters[$item])" -Target $hashParameters[$item]
        Set-Variable -Name $name -Value $hashParameters[$item] -Scope Script
    }
}