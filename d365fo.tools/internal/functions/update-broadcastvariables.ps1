
<#
    .SYNOPSIS
        Update the broadcast message config variables
        
    .DESCRIPTION
        Update the active broadcast message config variables that the module will use as default values
        
    .EXAMPLE
        PS C:\> Update-BroadcastVariables
        
        This will update the broadcast variables.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Update-BroadcastVariables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType()]
    param ( )

    $configName = (Get-PSFConfig -FullName "d365fo.tools.active.broadcast.message.config.name").Value.ToString().ToLower()
    if (-not ($configName -eq "")) {
        $hashParameters = Get-D365ActiveBroadcastMessageConfig -OutputAsHashtable
        foreach ($item in $hashParameters.Keys) {
            if ($item -eq "name") { continue }
            
            $name = "Broadcast" + (Get-Culture).TextInfo.ToTitleCase($item)
        
            $valueMessage = $hashParameters[$item]

            if ($item -like "*client*" -and $valueMessage.Length -gt 20)
            {
                $valueMessage = $valueMessage.Substring(0,18) + "[...REDACTED...]"
            }

            Write-PSFMessage -Level Verbose -Message "$name - $valueMessage" -Target $valueMessage
            Set-Variable -Name $name -Value $hashParameters[$item] -Scope Script
        }
    }
}