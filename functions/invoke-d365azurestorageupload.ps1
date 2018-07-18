<#
.SYNOPSIS
Upload a file to Azure

.DESCRIPTION
Upload any file to an Azure Storage Account

.PARAMETER AccountId
Storage Account Name / Storage Account Id where you want to store the file

.PARAMETER AccessToken
The token that has the needed permissions for the upload action

.PARAMETER Blobname
Name of the container / blog inside the storage account you want to store the file

.PARAMETER Filepath
Path to the file you want to upload

.PARAMETER DeleteOnUpload
Switch to tell the cmdlet if you want the local file to be deleted after the upload completes

.EXAMPLE
Invoke-D365AzureStorageUpload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Filepath c:\temp\bacpac\UAT_20180701.bacpac -DeleteOnUpload

.NOTES
The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.

#>
function Invoke-D365AzureStorageUpload {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', Position = 1 )]
        [string] $AccountId,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 2 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', Position = 2 )]
        [string] $AccessToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 3 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', Position = 3 )]
        [string] $Blobname,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipeline = $true, Position = 4 )] 
        [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true, Position = 4 )]
        [Alias('File')]
        [string] $Filepath,

        [switch] $DeleteOnUpload
    )
    BEGIN {

        if (Get-Module -ListAvailable -Name "Azure.Storage") {
            Import-Module "Azure.Storage"
        }
        else {
            Write-Host "The Azure.Storage powershell module is not present on the system. This is an important part of making it possible to uplaod files to Azure Storage. Please install module on the machine and run the cmdlet again. `r`nRun the following command in an elevated powershell windows :`r`nInstall-Module `"Azure.Storage`"" -ForegroundColor Yellow
            Write-Error "The Azure.Storage powershell module is not installed on the machine. Please install the module and run the command again." -ErrorAction Stop
        }
    }
    PROCESS {
        $storageContext = new-AzureStorageContext -StorageAccountName $AccountId -StorageAccountKey $AccessToken

        $cloudStorageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($storageContext.ConnectionString)

        $blobClient = $cloudStorageAccount.CreateCloudBlobClient()

        $blobcontainer = $blobClient.GetContainerReference($Blobname);

        try {
            $FileName = Split-Path $Filepath -Leaf
            $blockBlob = $blobcontainer.GetBlockBlobReference($FileName);
            $blockBlob.UploadFromFile($Filepath)

            if ($DeleteOnUpload.IsPresent) {
                Remove-Item $Filepath -Force
            }

            [PSCustomObject]@{
                File = $Filepath
                Filename = $FileName
            }
        }
        catch {

        }
    }

    END {}
}