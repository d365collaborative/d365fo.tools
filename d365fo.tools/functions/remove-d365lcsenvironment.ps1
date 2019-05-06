
<#
    .SYNOPSIS
        Remove lcs environment
        
    .DESCRIPTION
        Remove a lcs environment from the configuration store
        
    .PARAMETER Name
        Name of the lcs environment you want to remove from the configuration store
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily remove the lcs environment from the configuration store
        
    .EXAMPLE
        PS C:\> Remove-D365LcsEnvironment -Name "UAT"
        
        This will remove the lcs environment named "UAT" from the machine.
        
    .NOTES
        Tags: Servicing, Environment, Config, Configuration,
        
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

function Remove-D365LcsEnvironment {
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

    if (-not ((Get-PSFConfig -FullName "d365fo.tools.lcs.environment.*.name").Value -contains $Name)) {
        Write-PSFMessage -Level Host -Message "A lcs environment with that name <c='em'>doesn't exists</c>."
        Stop-PSFFunction -Message "Stopping because a lcs environment with that name doesn't exists."
        return
    }

    foreach ($config in Get-PSFConfig -FullName "d365fo.tools.lcs.environment.$Name.*") {
        Set-PSFConfig -FullName $config.FullName -Value ""

        if (-not $Temporary) { Unregister-PSFConfig -FullName $config.FullName -Scope UserDefault }
    }
}