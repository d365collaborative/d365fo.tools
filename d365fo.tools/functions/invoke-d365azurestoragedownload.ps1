
<#
    .SYNOPSIS
        Download a file to Azure
        
    .DESCRIPTION
        Download any file to an Azure Storage Account
        
    .PARAMETER AccountId
        Storage Account Name / Storage Account Id where you want to fetch the file from
        
    .PARAMETER AccessToken
        The token that has the needed permissions for the download action
        
    .PARAMETER SAS
        The SAS key that you have created for the storage account or blob container
        
    .PARAMETER Blobname
        Name of the container / blog inside the storage account you where the file is
        
    .PARAMETER FileName
        Name of the file that you want to download
        
    .PARAMETER Path
        Path to the folder / location you want to save the file
        
        The default path is "c:\temp\d365fo.tools"
        
    .PARAMETER GetLatest
        Switch to tell the cmdlet just to download the latest file from Azure regardless of name
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -FileName "OriginalUAT.bacpac" -Path "c:\temp"
        
        Will download the "OriginalUAT.bacpac" file from the storage account and save it to "c:\temp\OriginalUAT.bacpac"
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Path "c:\temp" -GetLatest
        
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
        The complete path to the file will returned as output from the cmdlet.
        
    .EXAMPLE
        PS C:\> $AzureParams = Get-D365ActiveAzureStorageConfig
        PS C:\> Invoke-D365AzureStorageDownload @AzureParams -Path "c:\temp" -GetLatest
        
        This will get the current Azure Storage Account configuration details
        and use them as parameters to download the latest file from an Azure Storage Account
        
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
        The complete path to the file will returned as output from the cmdlet.
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageDownload -GetLatest
        
        This will use the default parameter values that are based on the configuration stored inside "Get-D365ActiveAzureStorageConfig".
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\d365fo.tools".
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageDownload -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Blobname "backupfiles" -Path "c:\temp" -GetLatest
        
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
        A SAS key is used to gain access to the container and downloading the file from it.
        The complete path to the file will returned as output from the cmdlet.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Latest, Bacpac
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Invoke-D365AzureStorageDownload {
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

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true)]
        [Alias('Name')]
        [string] $FileName,

        [Parameter(Mandatory = $false)]
        [string] $Path = $Script:DefaultTempPath,

        [Parameter(Mandatory = $true, ParameterSetName = 'Latest', Position = 4 )]
        [switch] $GetLatest
    )

    BEGIN {
        if (-not (Test-PathExists -Path $Path -Type Container -Create)) {
            return
        }

        if (([string]::IsNullOrEmpty($AccountId) -eq $true) -or
            ([string]::IsNullOrEmpty($Blobname)) -or
            (([string]::IsNullOrEmpty($AccessToken)) -and ([string]::IsNullOrEmpty($SAS)))) {
            Write-PSFMessage -Level Host -Message "It seems that you are missing some of the parameters. Please make sure that you either supplied them or have the right configuration saved."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }
    PROCESS {
        if (Test-PSFFunctionInterrupt) {return}

        Invoke-TimeSignal -Start

        try {

            if ([string]::IsNullOrEmpty($SAS)) {
                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with AccessToken"

                $storageContext = new-AzureStorageContext -StorageAccountName $AccountId.ToLower() -StorageAccountKey $AccessToken
            }
            else {
                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with SAS"

                $conString = $("BlobEndpoint=https://{0}.blob.core.windows.net/;QueueEndpoint=https://{0}.queue.core.windows.net/;FileEndpoint=https://{0}.file.core.windows.net/;TableEndpoint=https://{0}.table.core.windows.net/;SharedAccessSignature={1}" -f $AccountId.ToLower(), $SAS)
                $storageContext = new-AzureStorageContext -ConnectionString $conString
            }

            $cloudStorageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($storageContext.ConnectionString)

            $blobClient = $cloudStorageAccount.CreateCloudBlobClient()

            $blobContainer = $blobClient.GetContainerReference($Blobname.ToLower());

            Write-PSFMessage -Level Verbose -Message "Start download from Azure Storage Account"

            if ($GetLatest.IsPresent) {
                $files = $blobContainer.ListBlobs()
                $File = ($files | Sort-Object -Descending { $_.Properties.LastModified } | Select-Object -First 1)
    
                $NewFile = Join-Path $Path $($File.Name)

                $File.DownloadToFile($NewFile, [System.IO.FileMode]::Create)
            }
            else {
                $NewFile = Join-Path $Path $FileName

                $blockBlob = $blobContainer.GetBlockBlobReference($FileName);
                $blockBlob.DownloadToFile($NewFile, [System.IO.FileMode]::Create)
            }

            [PSCustomObject]@{
                File     = $NewFile
                Filename = $FileName
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while downloading the file from Azure" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally {
            Invoke-TimeSignal -End
        }
    }

    END {}
}