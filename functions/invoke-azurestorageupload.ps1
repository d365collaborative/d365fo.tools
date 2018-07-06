function Invoke-AzureStorageUpload {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]            
        [string] $AccountId,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 2 )]            
        [string] $AccessToken,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 3 )]            
        [string] $Blobname,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipeline = $true, Position = 4 )]         
        [string] $Filepath,

        [switch] $DeleteOnUpload
    )

    if (Get-Module -ListAvailable -Name "Azure.Storage") {
        Import-Module "Azure.Storage"    
    }
    else {
        Write-Host "The Azure.Storage powershell module is not present on the system. This is an important part of making it possible to uplaod files to Azure Storage. Please install module on the machine and run the cmdlet again. `r`nRun the following command in an elevated powershell windows :`r`nInstall-Module `"Azure.Storage`"" -ForegroundColor Yellow
        Write-Error "The Azure.Storage powershell module is not installed on the machine. Please install the module and run the command again." -ErrorAction Stop
    }
    
    $storageContext = new-AzureStorageContext -StorageAccountName $AccountId -StorageAccountKey $AccessToken

    $cloudStorageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($storageContext.ConnectionString)
    
    $blobClient = $cloudStorageAccount.CreateCloudBlobClient()

    $blobcontainer = $blobClient.GetContainerReference($Blobname);

    try {
        $FileName = Split-Path $Filepath -Leaf
        $blockBlob = $blobcontainer.GetBlockBlobReference($FileName);
        $blockBlob.UploadFromFile($Filepath)

        if($DeleteOnUpload.IsPresent)
        {
            Remove-Item $Filepath -Force
        }
    }
    catch {
        
    }
}