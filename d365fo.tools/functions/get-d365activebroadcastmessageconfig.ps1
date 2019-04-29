
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