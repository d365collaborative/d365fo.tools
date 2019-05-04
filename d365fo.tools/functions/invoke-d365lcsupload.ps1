
<#
    .SYNOPSIS
        Upload a file to a LCS project
        
    .DESCRIPTION
        Upload a file to a LCS project using the API provided by Microsoft
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
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
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsUpload -ProjectId 123456789 -BearerToken "sdaflkja21jlkfjfdsa" -FilePath "C:\temp\d365fo.tools\GOLDEN.bacpac" -FileType "DatabaseBackup" -FileName "ReadyForTesting" -FileDescription "Contains all customers & vendors" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will upload the "C:\temp\d365fo.tools\GOLDEN.bacpac" file to the LCS project 123456789.
        The file will be placed in the sub folder "Database Backup".
        The file will be named "ReadyForTesting" inside the Asset Library in LCS.
        The file is uploaded against the NON-EUROPE LCS API.
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\GOLDEN.bacpac" -FileType "DatabaseBackup" -FileName "ReadyForTesting" -FileDescription "Contains all customers & vendors"
        
        This will upload the "C:\temp\d365fo.tools\GOLDEN.bacpac" file.
        The file will be placed in the sub folder "Database Backup".
        The file will be named "ReadyForTesting" inside the Asset Library in LCS.
        
        The ProjectId, ClientId, Username, Password and LcsApiUri parameters are read from the configuration storage, that is configured by the Set-D365LcsUploadConfig cmdlet.
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365LcsUpload {
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [int]$ProjectId = $Script:LcsApiProjectId,
        
        [Parameter(Mandatory = $false, Position = 2)]
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true, Position = 5)]
        [string] $FilePath,

        [Parameter(Mandatory = $false, Position = 6)]
        [string] $FileType = "Software Deployable Package",

        [Parameter(Mandatory = $false, Position = 7)]
        [string] $FileName,

        [Parameter(Mandatory = $false, Position = 8)]
        [string] $FileDescription,

        [Parameter(Mandatory = $false, Position = 9)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri
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