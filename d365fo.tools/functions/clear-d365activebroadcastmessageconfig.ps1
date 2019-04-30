
<#
    .SYNOPSIS
        Clear the active broadcast message config
        
    .DESCRIPTION
        Clear the active broadcast message config from the configuration store
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily clear the active broadcast message configuration in the configuration store
        
    .EXAMPLE
        PS C:\> Clear-D365ActiveBroadcastMessageConfig
        
        This will clear the active broadcast message configuration from the configuration store.
        
    .NOTES
        Tags: Servicing, Broadcast, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Add-D365BroadcastMessageConfig
        
    .LINK
        Get-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365BroadcastMessageConfig
        
    .LINK
        Remove-D365BroadcastMessageConfig
        
    .LINK
        Send-D365BroadcastMessage
        
    .LINK
        Set-D365ActiveBroadcastMessageConfig
#>

function Clear-D365ActiveBroadcastMessageConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [switch] $Temporary
    )

    $configurationName = "d365fo.tools.active.broadcast.message.config.name"
    
    Reset-PSFConfig -FullName $configurationName

    if (-not $Temporary) { Register-PSFConfig -FullName $configurationName -Scope UserDefault }
}