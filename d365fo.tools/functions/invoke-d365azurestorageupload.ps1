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

.EXAMPLE
$AzureParams = Get-D365ActiveAzureStorageConfig
New-D365Bacpac | Invoke-D365AzureStorageUpload @AzureParams

This will get the current Azure Storage Account configuration details and use them as parameters to upload the file to an Azure Storage Account.

.NOTES
The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.

Author: Mötz Jensen (@Splaxi)

#>
function Invoke-D365AzureStorageUpload {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, Position = 1 )]
        [string] $AccountId = $Script:AccountId,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $AccessToken = $Script:AccessToken,

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $Blobname = $Script:Blobname,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipeline = $true, Position = 4 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true, Position = 4 )]
        [Alias('File')]
        [string] $Filepath,

        [switch] $DeleteOnUpload
    )
    BEGIN {
        if (([string]::IsNullOrEmpty($AccountId) -eq $true) -or
            ([string]::IsNullOrEmpty($AccessToken)) -or ([string]::IsNullOrEmpty($Blobname))) {
            Write-PSFMessage -Level Host -Message "It seems that you are missing some of the parameters. Please make sure that you either supplied them or have the right configuration saved."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }
    PROCESS {
        if (Test-PSFFunctionInterrupt) {return}

        Invoke-TimeSignal -Start

        $storageContext = new-AzureStorageContext -StorageAccountName $AccountId -StorageAccountKey $AccessToken

        $cloudStorageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($storageContext.ConnectionString)

        $blobClient = $cloudStorageAccount.CreateCloudBlobClient()

        $blobcontainer = $blobClient.GetContainerReference($Blobname);

        try {
            Write-PSFMessage -Level Verbose -Message "Start uploading the file to Azure" -Exception $PSItem.Exception

            $FileName = Split-Path $Filepath -Leaf
            $blockBlob = $blobcontainer.GetBlockBlobReference($FileName)
            $blockBlob.UploadFromFile($Filepath)

            if ($DeleteOnUpload) {
                Remove-Item $Filepath -Force
            }

            [PSCustomObject]@{
                File     = $Filepath
                Filename = $FileName
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally {
            Invoke-TimeSignal -End
        }
    }

    END {}
}