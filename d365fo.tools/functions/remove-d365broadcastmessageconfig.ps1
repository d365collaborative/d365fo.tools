
<#
    .SYNOPSIS
        Remove broadcast message configuration
        
    .DESCRIPTION
        Remove a broadcast message configuration from the configuration store
        
    .PARAMETER Name
        Name of the broadcast message configuration you want to remove from the configuration store
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily remove the broadcast message configuration from the configuration store
        
    .EXAMPLE
        PS C:\> Remove-D365BroadcastMessageConfig -Name "UAT"
        
        This will remove the broadcast message configuration name "UAT" from the machine.
        
    .NOTES
        Tags: Servicing, Broadcast, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret
        
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
        Send-D365BroadcastMessage
        
    .LINK
        Set-D365ActiveBroadcastMessageConfig
#>

function Remove-D365BroadcastMessageConfig {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $Name,

        [switch] $Temporary
    )

    $Name = $Name.ToLower()

    if ($Name -match '\*') {
        Write-PSFMessage -Level Host -Message "The name cannot contain <c='em'>wildcard character</c>."
        Stop-PSFFunction -Message "Stopping because the name contains wildcard character."
        return
    }

    if (-not ((Get-PSFConfig -FullName "d365fo.tools.broadcast.*.name").Value -contains $Name)) {
        Write-PSFMessage -Level Host -Message "A broadcast message configuration with that name <c='em'>doesn't exists</c>."
        Stop-PSFFunction -Message "Stopping because a broadcast message configuration with that name doesn't exists."
        return
    }

    $res = (Get-PSFConfig -FullName "d365fo.tools.active.broadcast.message.config.name").Value

    if ($res -eq $Name) {
        Write-PSFMessage -Level Host -Message "The active broadcast message configuration is the <c='em'>same as the one you're trying to remove</c>. Please set another configuration as active, before removing this one. You could also call Clear-D365ActiveBroadcastMessageConfig."
        Stop-PSFFunction -Message "Stopping because the active broadcast message configuration is the same as the one trying to be removed."
        return
    }

    foreach ($config in Get-PSFConfig -FullName "d365fo.tools.broadcast.$Name.*") {
        Set-PSFConfig -FullName $config.FullName -Value ""

        if (-not $Temporary) { Unregister-PSFConfig -FullName $config.FullName -Scope UserDefault }
    }
}