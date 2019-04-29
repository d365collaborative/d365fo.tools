
<#
    .SYNOPSIS
        Get broadcast message configs
        
    .DESCRIPTION
        Get all broadcast message configuration objects from the configuration store
        
    .PARAMETER Name
        The name of the broadcast message configuration you are looking for
        
        Default value is "*" to display all broadcast message configs
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hastable object
        
    .EXAMPLE
        PS C:\> Get-D365BroadcastMessageConfig
        
        This will display all broadcast message configurations on the machine.
        
    .EXAMPLE
        PS C:\> Get-D365BroadcastMessageConfig -OutputAsHashtable
        
        This will display all broadcast message configurations on the machine.
        Every object will be output as a hashtable, for you to utilize as parameters for other cmdlets.
        
    .EXAMPLE
        PS C:\> Get-D365BroadcastMessageConfig -Name "UAT"
        
        This will display the broadcast message configuration that is saved with the name "UAT" on the machine.
        
    .NOTES
        Tags: Servicing, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-D365BroadcastMessageConfig {
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param (
        [string] $Name = "*",

        [switch] $OutputAsHashtable
    )

    Write-PSFMessage -Level Verbose -Message "Fetch all configurations based on $Name" -Target $Name

    $configurations = Get-PSFConfig -FullName "d365fo.tools.broadcast.$Name.name"

    foreach ($configName in $configurations.Value.ToLower()) {
        Write-PSFMessage -Level Verbose -Message "Working against the $configName configuration" -Target $configName
        $res = @{}

        foreach ($config in Get-PSFConfig -FullName "d365fo.tools.broadcast.$configName.*") {
            $propertyName = $config.FullName.ToString().Replace("d365fo.tools.broadcast.$configName.", "")
            $res.$propertyName = $config.Value
        }
        
        if($OutputAsHashtable) {
            $res
        } else {
            [PSCustomObject]$res
        }
    }
}