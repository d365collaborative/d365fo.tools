
<#
    .SYNOPSIS
        Save a lcs environment
        
    .DESCRIPTION
        Adds a lcs environment to the configuration store
        
    .PARAMETER Name
        The logical name of the lcs environment you are about to register in the configuration store
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily add the broadcast message configuration in the configuration store
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the broadcast message configuration with the same name
        
    .EXAMPLE
        PS C:\> Add-D365LcsEnvironment -Name "UAT" -ProjectId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will create a new lcs environment entry.
        The name of the registration is determined by the Name "UAT".
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
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
        
    .NOTES
        Tags: Servicing, Broadcast, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Mötz Jensen (@Splaxi)
#>

function Add-D365LcsEnvironment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [int] $ProjectId,

        [Parameter(Mandatory = $false)]
        [string] $EnvironmentId,

        [switch] $Temporary,

        [switch] $Force
    )
    
    if (((Get-PSFConfig -FullName "d365fo.tools.lcs.environment.*.name").Value -contains $Name) -and (-not $Force)) {
        Write-PSFMessage -Level Host -Message "A LCS environment configuration with <c='em'>$Name</c> as name <c='em'>already exists</c>. If you want to <c='em'>overwrite</c> the current configuration, please supply the <c='em'>-Force</c> parameter."
        Stop-PSFFunction -Message "Stopping because a environment configuration already exists with that name."
        return
    }

    $configName = ""

    #The ':keys' label is used to have a continue inside the switch statement itself
    :keys foreach ($key in $PSBoundParameters.Keys) {
        
        $configurationValue = $PSBoundParameters.Item($key)
        $configurationName = $key.ToLower()
        $fullConfigName = ""

        Write-PSFMessage -Level Verbose -Message "Working on $key with $configurationValue" -Target $configurationValue
        
        switch ($key) {
            "Name" {
                $configName = $Name.ToLower()
                $fullConfigName = "d365fo.tools.lcs.environment.$configName.name"
            }

            {"Temporary","Force" -contains $_} {
                continue keys
            }

            Default {
                $fullConfigName = "d365fo.tools.lcs.environment.$configName.$configurationName"
            }
        }

        Write-PSFMessage -Level Verbose -Message "Setting $fullConfigName to $configurationValue" -Target $configurationValue
        Set-PSFConfig -FullName $fullConfigName -Value $configurationValue
        if (-not $Temporary) { Register-PSFConfig -FullName $fullConfigName -Scope UserDefault }
    }
}