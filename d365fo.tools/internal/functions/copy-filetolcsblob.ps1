
<#
    .SYNOPSIS
        Copy local file to Azure Blob Storage
        
    .DESCRIPTION
        Copy local file to Azure Blob Storage that is used by LCS
        
    .PARAMETER FilePath
        Path to the file you want to upload to the Azure Blob storage
        
    .PARAMETER FullUri
        The full URI, including SAS token and Policy Permissions to the blob
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Copy-FileToLcsBlob -FilePath "C:\temp\d365fo.tools\GOLDEN.bacpac" -FullUri "https://uswedpl1catalog.blob.core.windows.net/...."
        
        This will upload the "C:\temp\d365fo.tools\GOLDEN.bacpac" to the "https://uswedpl1catalog.blob.core.windows.net/...." Blob Storage location.
        It is required that the FullUri contains all the needed SAS tokens and Policy Permissions for the upload to succeed.
        
    .NOTES
        Tags: Azure Blob, LCS, Upload
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Copy-FileToLcsBlob {
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,
        
        [Parameter(Mandatory = $true)]
        [System.Uri]$FullUri,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Initializing the needed .net objects to work against Azure Blob." -Target $FullUri
    $cloudblob = New-Object -TypeName Microsoft.WindowsAzure.Storage.Blob.CloudBlockBlob -ArgumentList @($FullUri)

    try {
        $uploadResult = Get-AsyncResult -Task $cloudblob.UploadFromFileAsync([System.String]$FilePath)
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while uploading the desired file to Azure Blob." -Exception $PSItem.Exception -Target $FullUri
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
 
    Invoke-TimeSignal -End
    
    $uploadResult
}