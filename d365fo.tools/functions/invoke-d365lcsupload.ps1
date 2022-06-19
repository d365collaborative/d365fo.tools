
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
        
    .PARAMETER Name
        Name to be assigned / shown on LCS
        
    .PARAMETER Filename
        Filename to be assigned / shown on LCS
        
        Often will it require an extension for it to be accepted
        
    .PARAMETER FileDescription
        Description to be assigned / shown on LCS
        
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
        
    .PARAMETER FailOnErrorMessage
        Instruct the cmdlet to write logging information to the console, if there is an error message in the response from the LCS endpoint
        
        Used in combination with either Enable-D365Exception cmdlet, or the -EnableException directly on this cmdlet, it will throw an exception and break/stop execution of the script
        This allows you to implement custom retry / error handling logic
        
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
        PS C:\> Invoke-D365LcsUpload -ProjectId 123456789 -BearerToken "Bearer JldjfafLJdfjlfsalfd..." -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -FileType "SoftwareDeployablePackage" -Name "Release-2019-05-05" -Filename "Release-2019-05-05.zip" -FileDescription "Build based on sprint: SuperSprint-1" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the upload of a file to the Asset Library.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
        The file type "Software Deployable Package" determines where inside the Asset Library the file will end up.
        The name inside the Asset Library is based on the Name "Release-2019-05-05".
        The file name inside the Asset Library is based on the FileName "Release-2019-05-05.zip".
        The description inside the Asset Library is based on the FileDescription "Build based on sprint: SuperSprint-1".
        The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -FileType "SoftwareDeployablePackage" -FileName "Release-2019-05-05.zip"
        
        This will start the upload of a file to the Asset Library.
        The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
        The file type "Software Deployable Package" determines where inside the Asset Library the file will end up.
        The file name inside the Asset Library is based on the FileName "Release-2019-05-05.zip".
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip"
        
        This will start the upload of a file to the Asset Library.
        The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" -RetryTimeout "00:01:00"
        
        This will start the upload of a file to the Asset Library through the LCS API, and allow for the cmdlet to retry for no more than 1 minute.
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

        [string] $Name,

        [string] $Filename,

        [string] $FileDescription,

        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $FailOnErrorMessage,
        
        [Timespan] $RetryTimeout = "00:00:00",
        
        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    $fileNameExtracted = Split-Path $FilePath -Leaf

    if ($Filename -eq "") {
        $Filename = $fileNameExtracted
    }

    if ($Name -eq "") {
        $Name = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
    }

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }
    
    $blobDetails = Start-LcsUploadV2 -Token $BearerToken -ProjectId $ProjectId -FileType $FileType -LcsApiUri $LcsApiUri -Name $Name -FileName $Filename -Description $FileDescription -RetryTimeout $RetryTimeout

    if (Test-PSFFunctionInterrupt) { return }

    if ($FailOnErrorMessage -and $blobDetails.ErrorMessage) {
        $messageString = "The request against LCS succeeded, but the response was an error message for the operation: <c='em'>$($blobDetails.ErrorMessage)</c>."
        $errorMessagePayload = "`r`n$($blobDetails | ConvertTo-Json)"
        Write-PSFMessage -Level Host -Message $messageString -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $blobDetails
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $blobDetails
    }

    Write-PSFMessage -Level Verbose -Message "Start response" -Target $blobDetails

    $uploadResponse = Copy-FileToLcsBlob -FilePath $FilePath -FullUri $blobDetails.FileLocation

    if (Test-PSFFunctionInterrupt) { return }

    Write-PSFMessage -Level Verbose -Message "Upload response" -Target $uploadResponse

    $ackResponse = Complete-LcsUploadV2 -Token $BearerToken -ProjectId $ProjectId -AssetId $blobDetails.Id -LcsApiUri $LcsApiUri -RetryTimeout $RetryTimeout

    if (Test-PSFFunctionInterrupt) { return }

    if ($FailOnErrorMessage -and $ackResponse.ErrorMessage) {
        $messageString = "The request against LCS succeeded, but the response was an error message for the operation: <c='em'>$($ackResponse.ErrorMessage)</c>."
        $errorMessagePayload = "`r`n$($ackResponse | ConvertTo-Json)"
        Write-PSFMessage -Level Host -Message $messageString -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $ackResponse
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $ackResponse
    }

    Write-PSFMessage -Level Verbose -Message "Commit response" -Target $ackResponse

    Invoke-TimeSignal -End

    [PSCustomObject]@{
        AssetId  = $blobDetails.Id
        Name     = $Name
        Filename = $Filename
    }
}