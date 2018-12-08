
<#
    .SYNOPSIS
        Get a hashtable with all the stored parameters
        
    .DESCRIPTION
        Gets a hashtable with all the stored parameters to be used with Import-D365Bacpac or New-D365Bacpac for Tier 2 environments
        
    .EXAMPLE
        PS C:\> $params = Get-D365Tier2Params
        
        This will extract the stored parameters and create a hashtable object.
        The hashtable is assigned to the $params variable.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Get-D365Tier2Params {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType()]
    param (    )

    $jsonString = Get-PSFConfigValue -FullName "d365fo.tools.tier2.bacpac.params"

    Write-PSFMessage -Level Verbose -Message "Retrieved json string" -Target $jsonString

    $jsonString | ConvertFrom-Json | ConvertTo-Hashtable
}