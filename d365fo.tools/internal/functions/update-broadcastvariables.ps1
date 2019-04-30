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
    [CmdletBinding()]
    [OutputType()]
    param ( )

    $configName = (Get-PSFConfig -FullName "d365fo.tools.active.broadcast.message.config.name").Value.ToString().ToLower()
    if (-not ($configName -eq "")) {
        $broadcastHash = Get-D365ActiveBroadcastMessageConfig -OutputAsHashtable
        foreach ($item in $broadcastHash.Keys) {
            if ($item -eq "name") { continue }
            
            $name = "Broadcast" + (Get-Culture).TextInfo.ToTitleCase($item)
        
            Write-PSFMessage -Level Verbose -Message "$name - $($broadcastHash[$item])" -Target $broadcastHash[$item]
            Set-Variable -Name $name -Value $broadcastHash[$item] -Scope Script
        }
    }
}