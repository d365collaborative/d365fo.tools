
<#
    .SYNOPSIS
        Set the details for the logic app invoke cmdlet
        
    .DESCRIPTION
        Store the needed details for the module to execute an Azure Logic App using a HTTP request
        
    .PARAMETER Url
        The URL for the http request endpoint of the desired
        logic app
        
    .PARAMETER Email
        The receiving email address that should be notified
        
    .PARAMETER Subject
        The subject of the email that you want to send
        
    .EXAMPLE
        PS C:\> Set-D365LogicAppConfig -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/
        
        This will set all the details about invoking the Logic App.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Set-D365LogicAppConfig {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true )]
        [string] $Url,

        [Parameter(Mandatory = $true )]
        [string] $Email,

        [Parameter(Mandatory = $true )]
        [string] $Subject
    )

    $Details = @{URL = $URL; Email = $Email;
        Subject = $Subject;
    }

    Set-PSFConfig -FullName "d365fo.tools.active.logic.app" -Value $Details
    Get-PSFConfig -FullName "d365fo.tools.active.logic.app" | Register-PSFConfig
}