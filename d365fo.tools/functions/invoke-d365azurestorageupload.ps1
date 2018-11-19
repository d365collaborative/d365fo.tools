
<#
    .SYNOPSIS
        Upload a file to Azure
        
    .DESCRIPTION
        Upload any file to an Azure Storage Account
        
    .PARAMETER AccountId
        Storage Account Name / Storage Account Id where you want to store the file
        
    .PARAMETER AccessToken
        The token that has the needed permissions for the upload action
        
    .PARAMETER SAS
        The SAS key that you have created for the storage account or blob container
        
    .PARAMETER Blobname
        Name of the container / blog inside the storage account you want to store the file
        
    .PARAMETER Filepath
        Path to the file you want to upload
        
    .PARAMETER DeleteOnUpload
        Switch to tell the cmdlet if you want the local file to be deleted after the upload completes
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageUpload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Filepath "c:\temp\bacpac\UAT_20180701.bacpac" -DeleteOnUpload
        
        This will upload the "c:\temp\bacpac\UAT_20180701.bacpac" up to the "backupfiles" container, inside the "miscfiles" Azure Storage Account that is access with the "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" token.
        After upload the local file will be deleted.
        
    .EXAMPLE
        PS C:\> $AzureParams = Get-D365ActiveAzureStorageConfig
        PS C:\> New-D365Bacpac | Invoke-D365AzureStorageUpload @AzureParams
        
        This will get the current Azure Storage Account configuration details and use them as parameters to upload the file to an Azure Storage Account.
        
    .EXAMPLE
        PS C:\> New-D365Bacpac | Invoke-D365AzureStorageUpload
        
        This will generate a new bacpac file using the "New-D365Bacpac" cmdlet.
        The file will be uploaded to an Azure Storage Account using the "Invoke-D365AzureStorageUpload" cmdlet.
        This will use the default parameter values that are based on the configuration stored inside "Get-D365ActiveAzureStorageConfig" for the "Invoke-D365AzureStorageUpload" cmdlet.
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageUpload -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Blobname "backupfiles" -Filepath "c:\temp\bacpac\UAT_20180701.bacpac" -DeleteOnUpload
        
        This will upload the "c:\temp\bacpac\UAT_20180701.bacpac" up to the "backupfiles" container, inside the "miscfiles" Azure Storage Account.
        A SAS key is used to gain access to the container and uploading the file to it.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Bacpac
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Invoke-D365AzureStorageUpload {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false)]
        [string] $AccountId = $Script:AccountId,

        [Parameter(Mandatory = $false)]
        [string] $AccessToken = $Script:AccessToken,

        [Parameter(Mandatory = $false)]
        [string] $SAS = $Script:SAS,

        [Parameter(Mandatory = $false)]
        [string] $Blobname = $Script:Blobname,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipeline = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true)]
        [Alias('File')]
        [Alias('Path')]
        [string] $Filepath,

        [switch] $DeleteOnUpload
    )
    BEGIN {
        if (([string]::IsNullOrEmpty($AccountId) -eq $true) -or
            ([string]::IsNullOrEmpty($Blobname)) -or
            (([string]::IsNullOrEmpty($AccessToken)) -and ([string]::IsNullOrEmpty($SAS)))) {
            Write-PSFMessage -Level Host -Message "It seems that you are missing some of the parameters. Please make sure that you either supplied them or have the right configuration saved."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }
    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }

        Invoke-TimeSignal -Start
        try {

            if ([string]::IsNullOrEmpty($SAS)) {
                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with AccessToken"

                $storageContext = new-AzureStorageContext -StorageAccountName $AccountId.ToLower() -StorageAccountKey $AccessToken
            }
            else {
                $conString = $("BlobEndpoint=https://{0}.blob.core.windows.net/;QueueEndpoint=https://{0}.queue.core.windows.net/;FileEndpoint=https://{0}.file.core.windows.net/;TableEndpoint=https://{0}.table.core.windows.net/;SharedAccessSignature={1}" -f $AccountId.ToLower(), $SAS)

                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with SAS" -Target $conString
                
                $storageContext = new-AzureStorageContext -ConnectionString $conString
            }

            $cloudStorageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($storageContext.ConnectionString)

            $blobClient = $cloudStorageAccount.CreateCloudBlobClient()

            $blobContainer = $blobClient.GetContainerReference($Blobname.ToLower());
        
            Write-PSFMessage -Level Verbose -Message "Start uploading the file to Azure"

            $FileName = Split-Path $Filepath -Leaf
            $blockBlob = $blobContainer.GetBlockBlobReference($FileName)
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
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the Azure Storage Account" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally {
            Invoke-TimeSignal -End
        }
    }

    END {}
}