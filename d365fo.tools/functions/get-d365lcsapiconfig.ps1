
<#
    .SYNOPSIS
        Get the LCS configuration details
        
    .DESCRIPTION
        Get the LCS configuration details from the configuration store
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiConfig
        
        This will return the saved configuration for accessing the LCS API.
        The object return will be a HashTable.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiConfig -OutputAsHashtable
        
        This will return the saved configuration for accessing the LCS API.
        The object return will be a PSCustomObject.
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365LcsApiConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [switch] $OutputAsHashtable
    )

    Invoke-TimeSignal -Start

    $res = [Ordered]@{}

    Write-PSFMessage -Level Verbose -Message "Extracting all the LCS configuration and building the result object."

    foreach ($config in Get-PSFConfig -FullName "d365fo.tools.lcs.*") {
        $propertyName = $config.FullName.ToString().Replace("d365fo.tools.lcs.", "")
        $res.$propertyName = $config.Value
    }

    if($OutputAsHashtable) {
        $res
    } else {
        [PSCustomObject]$res
    }

    Invoke-TimeSignal -End

}