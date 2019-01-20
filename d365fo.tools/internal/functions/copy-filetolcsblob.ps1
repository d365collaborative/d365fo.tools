function Copy-FileToLcsBlob {
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,
        
        [Parameter(Mandatory = $true)]
        [System.Uri]$FullUri
    )

    $cloudblob = New-Object -TypeName Microsoft.WindowsAzure.Storage.Blob.CloudBlockBlob -ArgumentList @($FullUri)

    $uploadResult = Get-AsyncResult -Task $cloudblob.UploadFromFileAsync([System.String]$FilePath)
    
    $uploadResult
}