<#
.SYNOPSIS
Get the registered details for Azure Logic App

.DESCRIPTION
Get the details that are stored for the module when
it has to invoke the Azure Logic App

.EXAMPLE
PS C:\> Get-D365LogicAppConfig

This will fetch the current registered Azure Logic App details on the machine.

.NOTES
Author: Mötz Jensen (@Splaxi)

#>
function Get-D365LogicAppConfig {
    [CmdletBinding()]
    param ()
    
    if ((Get-PSFConfig -FullName "d365fo.tools*").Count -eq 0) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>configuration objects</c> on the machine. Please make sure that you ran <c='em'>Initialize-D365Config</c> first."
        Stop-PSFFunction -Message "Stopping because unable to locate configuration objects."
        return
    }
    else {
        $Details = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.active.logic.app")
        
        $temp = [ordered]@{Email = $Details.Email;
        Subject = $Details.Subject; URL = $Details.URL}
        [PSCustomObject]$temp
    }
}