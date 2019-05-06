
<#
    .SYNOPSIS
        Get lcs environment
        
    .DESCRIPTION
        Get all lcs environment objects from the configuration store
        
    .PARAMETER Name
        The name of the lcs environment you are looking for
        
        Default value is "*" to display all lcs environments
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironment
        
        This will display all lcs environments on the machine.
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironment -OutputAsHashtable
        
        This will display all lcs environments on the machine.
        Every object will be output as a hashtable, for you to utilize as parameters for other cmdlets.
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironment -Name "UAT"
        
        This will display the lcs environment that is saved with the name "UAT" on the machine.
        
    .NOTES
        Tags: Servicing, Environment, Config, Configuration
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Get-D365LcsAssetValidationStatus
        
    .LINK
        Get-D365LcsDeploymentStatus
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
#>

function Get-D365LcsEnvironment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param (
        [string] $Name = "*",

        [switch] $OutputAsHashtable
    )
    
    Write-PSFMessage -Level Verbose -Message "Fetch all configurations based on $Name" -Target $Name

    $Name = $Name.ToLower()
    $configurations = Get-PSFConfig -FullName "d365fo.tools.lcs.environment.$Name.name"

    foreach ($configName in $configurations.Value.ToLower()) {
        Write-PSFMessage -Level Verbose -Message "Working against the $configName configuration" -Target $configName
        $res = @{}

        $configName = $configName.ToLower()

        foreach ($config in Get-PSFConfig -FullName "d365fo.tools.lcs.environment.$configName.*") {
            $propertyName = $config.FullName.ToString().Replace("d365fo.tools.lcs.environment.$configName.", "")
            $res.$propertyName = $config.Value
        }
        
        if($OutputAsHashtable) {
            $res
        } else {
            [PSCustomObject]$res
        }
    }
}