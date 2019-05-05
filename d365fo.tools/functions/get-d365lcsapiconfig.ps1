
<#
    .SYNOPSIS
        Get the LCS configuration details
        
    .DESCRIPTION
        Get the LCS configuration details from the configuration store
        
        All settings retrieved from this cmdlets is to be considered the default parameter values across the different cmdlets
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiConfig
        
        This will output the current LCS API configuration.
        The object returned will be a PSCustomObject.
        
    .EXAMPLE
        PS C:\> Get-D365LcsApiConfig -OutputAsHashtable
        
        This will output the current LCS API configuration.
        The object returned will be a Hashtable.
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Get-D365LcsAssetValidationStatus
        
    .LINK
        Get-D365LcsDeploymentStatus
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Invoke-D365LcsDeployment
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
        
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