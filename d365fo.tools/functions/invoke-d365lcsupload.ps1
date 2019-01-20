function Invoke-D365LcsUpload {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [int]$ProjectId = $Script:LcsUploadProjectid,
        
        [Parameter(Mandatory = $false, Position = 2)]
        [string] $ClientId = $Script:LcsUploadClientid,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $Username = $Script:LcsUploadUsername,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $Password = $Script:LcsUploadPassword,

        [Parameter(Mandatory = $true, Position = 5)]
        [string]$FilePath,

        [Parameter(Mandatory = $false, Position = 6)]
        [ValidateSet("DeployablePackage", "DatabaseBackup")]
        [string]$FileType = "DatabaseBackup",

        [Parameter(Mandatory = $false, Position = 7)]
        [string]$FileName,

        [Parameter(Mandatory = $false, Position = 8)]
        [string]$FileDescription,

        [Parameter(Mandatory = $false, Position = 9)]
        [ValidateSet("https://lcsapi.lcs.dynamics.com", "https://lcsapi.eu.lcs.dynamics.com")]
        [string]$LcsApiUri = $Script:LcsUploadApiUri
    )

    $scope = "openid"
    $grantType = "password"

    $authToken = Invoke-AadAuthentication -Resource $LcsApiUri -GrantType $grantType -ClientId $ClientId -Username $Username -Password $Password -Scope $scope
    
    $bearerToken = "Bearer {0}" -f $authToken

    $blobDetails = Start-LcsUpload -Token $bearerToken -ProjectId $ProjectId -FileType $FileType -FilePath $FilePath -LcsApiUri $LcsApiUri -Name $FileName -Description $FileDescription

    $uploadResponse = Copy-FileToLcsBlob -FilePath $FilePath -FullUri $blobDetails.FileLocation

    $ackResponse = Complete-LcsUpload -Token $bearerToken -ProjectId $ProjectId -AssetId $blobDetails.Id -LcsApiUri $LcsApiUri
}