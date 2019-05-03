
<#
    .SYNOPSIS
        Set the LCS configuration details
        
    .DESCRIPTION
        Set the LCS configuration details and save them into the configuration store
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER ClientId
        The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily override the persisted settings in the configuration storage
        
    .EXAMPLE
        PS C:\> Set-D365LcsUploadConfig -ProjectId 123456789 -ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" -Username claire@contoso.com -Password "pass@word1" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will save the ProjectId 123456789 and ClientId "9b4f4503-b970-4ade-abc6-2c086e4c4929" to be default values when using the Invoke-D365LcsUpload cmdlet.
        The Username Claire@contoso.com and the Password "pass@word1" will also be stored as default values when using the Invoke-D365LcsUpload cmdlet.
        The NON-EUROPE LCS API address will be configured as the endpoint when using the Invoke-D365LcsUpload cmdlet.
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Set-D365LcsUploadConfig {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingUserNameAndPassWordParams", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [int] $ProjectId,

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $ClientId,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 3)]
        [Alias('access_token')]
        [Alias('AccessToken')]
        [string] $BearerToken,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 4)]
        [Alias('expires_on')]
        [long] $ActiveTokenExpiresOn,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 5)]
        [Alias('refresh_token')]
        [string] $RefreshToken,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 6)]
        [Alias('resource')]
        [string] $LcsApiUri = "https://lcsapi.lcs.dynamics.com",
        
        [switch] $Temporary


    )

    #The ':keys' label is used to have a continue inside the switch statement itself
    :keys foreach ($key in $PSBoundParameters.Keys) {
        
        $configurationValue = $PSBoundParameters.Item($key)
        $configurationName = $key.ToLower()
        $fullConfigName = ""

        Write-PSFMessage -Level Verbose -Message "Working on $key with $configurationValue" -Target $configurationValue
        
        switch ($key) {
            "Temporary" {
                continue keys
            }

            Default {
                $fullConfigName = "d365fo.tools.lcs.$configurationName"
            }
        }

        Write-PSFMessage -Level Verbose -Message "Setting $fullConfigName to $configurationValue" -Target $configurationValue
        Set-PSFConfig -FullName $fullConfigName -Value $configurationValue
        if (-not $Temporary) { Register-PSFConfig -FullName $fullConfigName -Scope UserDefault }
    }

    Update-LcsUploadVariables
}