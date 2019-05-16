
<#
        
    .SYNOPSIS
        Set the active broadcast message configuration
        
    .DESCRIPTION
        Updates the current active broadcast message configuration with a new one
        
    .PARAMETER Name
        Name of the broadcast message configuration you want to load into the active broadcast message configuration
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily override the persisted settings in the configuration store
        
    .EXAMPLE
        PS C:\> Set-D365ActiveBroadcastMessageConfig -Name "UAT"
        
        This will set the broadcast message configuration named "UAT" as the active configuration.
        
    .NOTES
        Tags: Servicing, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret, OnPremise
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Add-D365BroadcastMessageConfig
        
    .LINK
        Clear-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365BroadcastMessageConfig
        
    .LINK
        Remove-D365BroadcastMessageConfig
        
    .LINK
        Send-D365BroadcastMessage
        
#>

function Set-D365ActiveBroadcastMessageConfig {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $Name,

        [switch] $Temporary
    )

    if($Name -match '\*') {
        Write-PSFMessage -Level Host -Message "The name cannot contain <c='em'>wildcard character</c>."
        Stop-PSFFunction -Message "Stopping because the name contains wildcard character."
        return
    }

    if (-not ((Get-PSFConfig -FullName "d365fo.tools.broadcast.*.name").Value -contains $Name)) {
        Write-PSFMessage -Level Host -Message "A broadcast message configuration with that name <c='em'>doesn't exists</c>."
        Stop-PSFFunction -Message "Stopping because a broadcast message configuration with that name doesn't exists."
        return
    }

    Set-PSFConfig -FullName "d365fo.tools.active.broadcast.message.config.name" -Value $Name
    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.active.broadcast.message.config.name"  -Scope UserDefault }

    Update-BroadcastVariables
}