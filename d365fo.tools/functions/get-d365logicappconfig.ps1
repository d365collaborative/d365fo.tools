
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
        Tags: LogicApp, Logic App, Configuration, Url, Email
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365LogicAppConfig {
    [CmdletBinding()]
    param ()
    
    $Details = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.active.logic.app")
        
    $temp = [ordered]@{Email = $Details.Email;
        Subject = $Details.Subject; URL = $Details.URL
    }
    
    [PSCustomObject]$temp
}