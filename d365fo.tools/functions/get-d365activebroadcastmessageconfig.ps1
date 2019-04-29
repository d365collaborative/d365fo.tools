
<#
    .SYNOPSIS
        Get active broadcast message configuration
        
    .DESCRIPTION
        Get active broadcast message configuration from the configuration store
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hastable object
        
    .EXAMPLE
        PS C:\> Get-D365ActiveBroadcastMessageConfig
        
        This will get the active broadcast message configuration.
        
    .NOTES
        Tags: Servicing, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-D365ActiveBroadcastMessageConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [switch] $OutputAsHashtable
    )

    $configName = (Get-PSFConfig -FullName "d365fo.tools.active.broadcast.name").Value

    if ($configName -eq "") {
        Write-PSFMessage -Level Host -Message "It looks like there <c='em'>isn't configured</c> an active broadcast message configuration."
        Stop-PSFFunction -Message "Stopping because an active broadcast message configuration wasn't found."
        return
    }

    Get-D365BroadcastMessageConfig -Name $configName -OutputAsHashtable:$OutputAsHashtable
}