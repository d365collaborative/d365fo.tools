
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
        
    .PARAMETER ConfigStorageLocation
        Parameter used to instruct where to store the configuration objects
        
        The default value is "User" and this will store all configuration for the active user
        
        Valid options are:
        "User"
        "System"
        
        "System" will store the configuration so all users can access the configuration objects
        
    .PARAMETER Temporary
        Switch to instruct the cmdlet to only temporarily override the persisted settings in the configuration storage
        
    .EXAMPLE
        PS C:\> Set-D365LogicAppConfig -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/
        
        This will set all the details about invoking the Logic App.
        
    .EXAMPLE
        PS C:\> Set-D365LogicAppConfig -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/ -ConfigStorageLocation "System"
        
        This will set all the details about invoking the Logic App.
        The data will be stored in the system wide configuration storage, which makes it accessible from all users.
        
    .EXAMPLE
        PS C:\> Set-D365LogicAppConfig -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/ -Temporary
        
        This will set all the details about invoking the Logic App.
        The update will only last for the rest of this PowerShell console session.
        
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
        [string] $Subject,

        [ValidateSet('User', 'System')]
        [string] $ConfigStorageLocation = "User",

        [switch] $Temporary
    )

    $configScope = Test-ConfigStorageLocation -ConfigStorageLocation $ConfigStorageLocation

    if (Test-PSFFunctionInterrupt) { return }

    $logicDetails = @{URL = $URL; Email = $Email;
        Subject = $Subject;
    }

    Set-PSFConfig -FullName "d365fo.tools.active.logic.app" -Value $logicDetails
    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.active.logic.app" -Scope $configScope }

    $Script:LogicAppEmail = $logicDetails.Email
    $Script:LogicAppSubject = $logicDetails.Subject
    $Script:LogicAppUrl = $logicDetails.Url
}