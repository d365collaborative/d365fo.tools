
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
        "E-Commerce Package"
        "NuGet Package"
        "Retail Self-Service Package"
        "Commerce Cloud Scale Unit Extension"
        
        
        Default value is "Software Deployable Package"
        
    .PARAMETER AssetName
        Name of the asset that you are looking for
        
        Accepts wildcards for searching. E.g. -AssetName "*ISV*"
        
        Default value is "*" which will search for all assets via the Name property
        
    .PARAMETER AssetVersion
        Version of the Asset file that you are looking for
        
        It does a simple compare against the response from LCS and only lists the ones that matches
        
        Accepts wildcards for searching. E.g. -AssetVersion "*ISV*"
        
        Default value is "*" which will search for all files
        
    .PARAMETER AssetFilename
        Name of the file that you are looking for
        
        Accepts wildcards for searching. E.g. -AssetFilename "*ISV*"
        
        Default value is "*" which will search for all files via the FileName property
        
    .PARAMETER AssetDescription
        Name of the file that you are looking for
        
        Accepts wildcards for searching. E.g. -AssetDescription "*ISV*"
        
        Default value is "*" which will search for all files via the FileDescription property
        
    .PARAMETER AssetId
        Id of the file that you are looking for
        
        Accepts wildcards for searching. E.g. -AssetId "*ISV*"
        
        Default value is "*" which will search for all files via the AssetId property
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        The value depends on where your LCS project is located. There are multiple valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.no.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER Latest
        Instruct the cmdlet to only fetch the latest file from the Asset Library from LCS
        
    .PARAMETER RetryTimeout
        The retry timeout, before the cmdlet should quit retrying based on the 429 status code
        
        Needs to be provided in the timspan notation:
        "hh:mm:ss"
        
        hh is the number of hours, numerical notation only
        mm is the number of minutes
        ss is the numbers of seconds
        
        Each section of the timeout has to valid, e.g.
        hh can maximum be 23
        mm can maximum be 59
        ss can maximum be 59
        
        Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -ProjectId 123456789 -FileType SoftwareDeployablePackage -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will list all Software Deployable Packages.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -FileType SoftwareDeployablePackage
        
        This will list all Software Deployable Packages.
        It will search for SoftwareDeployablePackage by using the FileType parameter.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -AssetFilename "*MAIN*"
        
        This will list all Software Deployable Packages, that matches the "*MAIN*" search pattern in the AssetFilename.
        It will search for SoftwareDeployablePackage by using the FileType parameter.
        It will filter the output to match the AssetFilename "*MAIN*" search pattern.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -AssetName "*MAIN*"
        
        This will list all Software Deployable Packages, that matches the "*MAIN*" search pattern in the AssetName.
        It will search for SoftwareDeployablePackage by using the FileType parameter.
        It will filter the output to match the AssetName "*MAIN*" search pattern.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -AssetDescription "*TEST*"
        
        This will list all Software Deployable Packages, that matches the "*TEST*" search pattern in the AssetDescription.
        It will search for SoftwareDeployablePackage by using the FileType parameter.
        It will filter the output to match the AssetDescription "*TEST*" search pattern.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -AssetId "500dd860-eacf-4e04-9f18-f9c8fe1d8e03"
        
        This will list all Software Deployable Packages, that matches the "500dd860-eacf-4e04-9f18-f9c8fe1d8e03" search pattern in the AssetId.
        It will search for SoftwareDeployablePackage by using the FileType parameter.
        It will filter the output to match the AssetId "500dd860-eacf-4e04-9f18-f9c8fe1d8e03" search pattern.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -Latest | Invoke-D365AzCopyTransfer -DestinationUri C:\Temp\d365fo.tools -FileName "Main.zip" -ShowOriginalProgress
        
        This will download the latest Software Deployable Package from the Asset Library in LCS onto your on machine.
        It will list Software Deployable Packages based on the FileType parameter.
        It will list the latest (newest) Software Deployable Package.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetFile -FileType SoftwareDeployablePackage -RetryTimeout "00:01:00"
        
        This will list all Software Deployable Packages, and allow for the cmdlet to retry for no more than 1 minute.
        It will search for SoftwareDeployablePackage by using the FileType parameter.
        
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
        
    .LINK
        Get-D365LcsSharedAssetFile
        
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

        [string] $AssetFilename = "*",

        [string] $AssetDescription = "*",

        [string] $AssetId = "*",
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [Alias('GetLatest')]
        [switch] $Latest,

        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }

    $assets = Get-LcsAssetFileV2 -BearerToken $BearerToken -ProjectId $ProjectId -LcsApiUri $LcsApiUri -FileType $([int]$FileType) -RetryTimeout $RetryTimeout

    if (Test-PSFFunctionInterrupt) { return }

    if ($Latest) {
        $assets | Sort-Object -Property "ModifiedDate" -Descending | Select-Object -First 1 | Select-PSFObject -TypeName "D365FO.TOOLS.Lcs.Asset.File" "*", "Id as AssetId"
    }
    else {
        foreach ($obj in $assets) {
            if ($obj.Name -NotLike $AssetName) { continue }
            if ($obj.Version -NotLike $AssetVersion) { continue }
            if ($obj.FileName -NotLike $AssetFilename) { continue }
            if ($obj.FileDescription -NotLike $AssetDescription) { continue }
            if ($obj.Id -NotLike $AssetId) { continue }

            $obj | Select-PSFObject -TypeName "D365FO.TOOLS.Lcs.Asset.File" "*", "Id as AssetId"
        }
    }

    Invoke-TimeSignal -End
}