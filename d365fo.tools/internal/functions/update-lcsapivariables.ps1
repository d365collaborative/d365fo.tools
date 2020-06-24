
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
        
        $valueMessage = $hashParameters[$item]

        if ($item -like "*client*" -and $valueMessage.Length -gt 20)
        {
            $valueMessage = $valueMessage.Substring(0,18) + "[...REDACTED...]"
        }

        Write-PSFMessage -Level Verbose -Message "$name - $valueMessage" -Target $valueMessage
        Set-Variable -Name $name -Value $hashParameters[$item] -Scope Script
    }
}