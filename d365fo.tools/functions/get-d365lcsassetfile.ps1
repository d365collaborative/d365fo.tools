
<#
    .SYNOPSIS
        Get file from the Asset library inside the LCS project
        
    .DESCRIPTION
        Get the available files from the Asset Library in LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER FileType
        Type of file you want to list from the LCS Asset Library
        
        Valid options:
        "Model"
        "Process Data Package"
        "Software Deployable Package"
        "GER Configuration"
        "Data Package"
        "PowerBI Report Model"
        
        Default value is "Software Deployable Package"
        
    .PARAMETER AssetName
        Name of the file that you are looking for
        
        Accepts wildcards for searching. E.g. -AssetName "*ISV*"
        
        Default value is "*" which will search for all files
        
    .PARAMETER AssetVersion
        Version of the Asset file that you are looking for
        
        It does a simple compare against the response from LCS and only lists the ones that matches
        
        Accepts wildcards for searching. E.g. -AssetName "*ISV*"
        
        Default value is "*" which will search for all files
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER Latest
        Instruct the cmdlet to only fetch the latest file from the Asset Library from LCS
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -ProjectId 123456789 -FileType SoftwareDeployablePackage -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the database refresh between the Source and Target environments.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -FileType SoftwareDeployablePackage
        
        This will list all Software Deployable Packages.
        It will search for SoftwareDeployablePackage by using the FileType parameter.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -Latest | Invoke-D365AzCopyTransfer -DestinationUri C:\Temp\d365fo.tools -FileName "Main.zip" -ShowOriginalProgress
        
        This will download the latest Software Deployable Package from the Asset Library in LCS onto your on machine.
        It will list Software Deployable Packages based on the FileType parameter.
        It will list the latest (newest) Software Deployable Package.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365LcsAssetFile {
    [CmdletBinding()]
    [OutputType()]
    param (
        [int] $ProjectId = $Script:LcsApiProjectId,

        [LcsAssetFileType] $FileType = [LcsAssetFileType]::SoftwareDeployablePackage,

        [string] $AssetName = "*",

        [string] $AssetVersion = "*",
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [Alias('GetLatest')]
        [switch] $Latest
    )

    Invoke-TimeSignal -Start

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }

    $assets = Get-LcsAssetFile -BearerToken $BearerToken -ProjectId $ProjectId -LcsApiUri $LcsApiUri -FileType $([int]$FileType)

    if (Test-PSFFunctionInterrupt) { return }

    if ($Latest) {
        $assets | Sort-Object -Property "ModifiedDate" -Descending | Select-Object -First 1 | Select-PSFObject -TypeName "D365FO.TOOLS.Lcs.Asset.File" "*","Id as AssetId"
    }
    else {
        foreach ($obj in $assets) {
            if ($obj.Name -NotLike $AssetName) { continue }
            if ($obj.Version -NotLike $AssetVersion) { continue }

            $obj | Select-PSFObject -TypeName "D365FO.TOOLS.Lcs.Asset.File" "*","Id as AssetId"
        }
    }

    Invoke-TimeSignal -End
}