<#
.SYNOPSIS
Set the LCS configuration details

.DESCRIPTION
Set the LCS configuration details and save them into the configuration store

.PARAMETER ProjectId
The project id for the Dynamics 365 for Finance & Operations project inside LCS

.PARAMETER ClientId
The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal

.PARAMETER Username
The username of the account that you want to impersonate

It can either be your personal account or a service account

.PARAMETER Password
The password of the account that you want to impersonate

.PARAMETER LcsApiUri
URI / URL to the LCS API you want to use

Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's

Valid options:
"https://lcsapi.lcs.dynamics.com"
"https://lcsapi.eu.lcs.dynamics.com"

.PARAMETER ConfigStorageLocation
        Parameter used to instruct where to store the configuration objects
        
        The default value is "User" and this will store all configuration for the active user
        
        Valid options are:
        "User"
        "System"
        
        "System" will store the configuration so all users can access the configuration objects

    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily override the persisted settings in the configuration storage

.PARAMETER Clear
Instruct the cmdlet to clear out all the stored configuration values

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
        [int]$ProjectId,

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $ClientId,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $Username,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $Password,

        [Parameter(Mandatory = $false, Position = 9)]
        [ValidateSet("https://lcsapi.lcs.dynamics.com", "https://lcsapi.eu.lcs.dynamics.com")]
        [string]$LcsApiUri = "https://lcsapi.lcs.dynamics.com",

        [ValidateSet('User', 'System')]
        [string] $ConfigStorageLocation = "User",

        [switch] $Temporary,

        [switch] $Clear
    )

    $configScope = Test-ConfigStorageLocation -ConfigStorageLocation $ConfigStorageLocation

    if (Test-PSFFunctionInterrupt) { return }

    if ($Clear) {

        Write-PSFMessage -Level Verbose -Message "Clearing all the d365fo.tools.lcs configurations."

        foreach ($item in (Get-PSFConfig -FullName d365fo.tools.lcs*)) {
            Set-PSFConfig -Fullname $item.FullName -Value ""
            if (-not $Temporary) { Register-PSFConfig -FullName $item.FullName -Scope $configScope }
        }
    }
    else {
        foreach ($key in $PSBoundParameters.Keys) {
            $value = $PSBoundParameters.Item($key)

            Write-PSFMessage -Level Verbose -Message "Working on $key with $value" -Target $value

            switch ($key) {
                "ProjectId" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.projectid" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.projectid" -Scope $configScope }
                }

                "ClientId" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.clientid" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.clientid" -Scope $configScope }
                }

                "Username" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.username" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.username" -Scope $configScope }
                }

                "Password" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.password" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.password" -Scope $configScope }
                }

                "LcsApiUri" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.api.uri" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.api.uri" -Scope $configScope }
                }

                Default {}
            }
        }
    }

    Write-PSFMessage -Level Verbose -Message "Rebuilding the LCS variables."

    foreach ($item in (Get-PSFConfig -FullName d365fo.tools.lcs*)) {
        $nameTemp = $item.FullName -replace "^d365fo.tools.", ""
        $name = ($nameTemp -Split "\." | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) } ) -Join ""
        
        Set-Variable -Name $name -Value $item.Value
    }
}