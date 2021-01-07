
<#
    .SYNOPSIS
        Upload a file to a LCS project
        
    .DESCRIPTION
        Upload a file to a LCS project using the API provided by Microsoft
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER FilePath
        Path to the file that you want to upload to the Asset Library on LCS
        
    .PARAMETER FileType
        Type of file you want to upload
        
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
        
    .PARAMETER FileName
        Name to be assigned / shown on LCS
        
    .PARAMETER FileDescription
        Description to be assigned / shown on LCS
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsUpload -ProjectId 123456789 -BearerToken "Bearer JldjfafLJdfjlfsalfd..." -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -FileType "SoftwareDeployablePackage" -FileName "Release-2019-05-05" -FileDescription "Build based on sprint: SuperSprint-1" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the upload of a file to the Asset Library.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
        The file type "Software Deployable Package" determines where inside the Asset Library the file will end up.
        The name inside the Asset Library is based on the FileName "Release-2019-05-05".
        The description inside the Asset Library is based on the FileDescription "Build based on sprint: SuperSprint-1".
        The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -FileType "SoftwareDeployablePackage" -FileName "Release-2019-05-05"
        
        This will start the upload of a file to the Asset Library.
        The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
        The file type "Software Deployable Package" determines where inside the Asset Library the file will end up.
        The name inside the Asset Library is based on the FileName "Release-2019-05-05".
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip"
        
        This will start the upload of a file to the Asset Library.
        The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
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
        Invoke-D365LcsDeployment
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365LcsUpload {
    [CmdletBinding()]
    [OutputType()]
    param(
        [int]$ProjectId = $Script:LcsApiProjectId,
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true)]
        [string] $FilePath,

        [LcsAssetFileType] $FileType = [LcsAssetFileType]::SoftwareDeployablePackage,

        [string] $FileName,

        [string] $FileDescription,

        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    $fileNameExtracted = Split-Path $FilePath -Leaf

    if ($FileName -eq "") {
        $FileName = $fileNameExtracted
    }

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }
    
    $blobDetails = Start-LcsUpload -Token $BearerToken -ProjectId $ProjectId -FileType $FileType -LcsApiUri $LcsApiUri -Name $FileName -Description $FileDescription

    if (Test-PSFFunctionInterrupt) { return }

    Write-PSFMessage -Level Verbose -Message "Start response" -Target $blobDetails

    $uploadResponse = Copy-FileToLcsBlob -FilePath $FilePath -FullUri $blobDetails.FileLocation

    if (Test-PSFFunctionInterrupt) { return }

    Write-PSFMessage -Level Verbose -Message "Upload response" -Target $uploadResponse

    $ackResponse = Complete-LcsUpload -Token $BearerToken -ProjectId $ProjectId -AssetId $blobDetails.Id -LcsApiUri $LcsApiUri

    if (Test-PSFFunctionInterrupt) { return }

    Write-PSFMessage -Level Verbose -Message "Commit response" -Target $ackResponse

    Invoke-TimeSignal -End

    [PSCustomObject]@{
        AssetId = $blobDetails.Id
        Name = $FileName
    }
}