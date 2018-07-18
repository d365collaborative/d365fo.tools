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
Name of the container / blog insidse the storage account you want to store the file

.PARAMETER FileName
Name of the file that you want to download

.PARAMETER Path
Path to the folder / location you want to save the file

.PARAMETER GetLatest
Switch to tell the cmdlet just to download the latest file from Azure regardless of name

.EXAMPLE
Invoke-D365AzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -FileName "OriginalUAT.bacpac" -Path "c:\temp" 

Will download the "OriginalUAT.bacpac" file from the storage account and save it to "c:\temp\OriginalUAT.bacpac"

.EXAMPLE
Invoke-D365AzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Path "c:\temp" -GetLatest

Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\". 
The complete path to the file will returned as output from the cmdlet.

.NOTES
The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.

#>
function Invoke-D365AzureStorageDownload {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'Latest', Position = 1 )]
        [string] $AccountId,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 2 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'Latest', Position = 2 )]
        [string] $AccessToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 3 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'Latest', Position = 3 )]
        [string] $Blobname,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 4 )] 
        [Alias('Name')]
        [string] $FileName,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 5 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'Latest', Position = 5 )]
        [string] $Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'Latest', Position = 4 )]
        [switch] $GetLatest
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
            if ($GetLatest.IsPresent) {
                $files = $blobcontainer.ListBlobs()
                $File = ($files | Sort-Object -Descending { $_.Properties.LastModified } | Select-Object -First 1)
    
                $NewFile = Join-Path $Path $($File.Name)

                $File.DownloadToFile($NewFile, [System.IO.FileMode]::Create)
            }
            else {
                $NewFile = Join-Path $Path $FileName

                $blockBlob = $blobcontainer.GetBlockBlobReference($FileName);
                $blockBlob.DownloadToFile($NewFile, [System.IO.FileMode]::Create)
            }

            [PSCustomObject]@{
                File = $NewFile
                Filename = $FileName
            }
        }
        catch [System.Exception] {
            Write-Host "Message: $($_.Exception.Message)"
            Write-Host "StackTrace: $($_.Exception.StackTrace)"
            Write-Host "LoaderExceptions: $($_.Exception.LoaderExceptions)"
        }
    }

    END {}
}