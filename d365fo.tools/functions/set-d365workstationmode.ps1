
<#
    .SYNOPSIS
        Set the Workstation mode
        
    .DESCRIPTION
        Set the Workstation mode to enabled or not
        
        It is used to enable the tool to run on a personal machine and still be able to call Invoke-D365TableBrowser and Invoke-D365SysRunnerClass
        
    .PARAMETER Enabled
        $True enables the workstation mode while $false deactivated the workstation mode
        
    .EXAMPLE
        PS C:\> Set-D365WorkstationMode -Enabled $true
        
        This will enable the Workstation mode.
        You will have to restart the powershell session when you switch around.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.
        
#>
function Set-D365WorkstationMode {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [boolean] $Enabled
    )

    Set-PSFConfig -FullName "d365fo.tools.workstation.mode" -Value $Enabled
    Register-PSFConfig -FullName "d365fo.tools.workstation.mode"

    Write-PSFMessage -Level Host -Message "Please <c='em'>restart</c> the powershell session / console. This change affects core functionality that <c='em'>requires</c> the module to be <c='em'>reloaded</c>."
}