
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
        
    .PARAMETER Container
        Name of the blob container inside the storage account you want to store the file
        
    .PARAMETER Filepath
        Path to the file you want to upload
        
    .PARAMETER ContentType
        Media type of the file that is going to be uploaded
        
        The value will be used for the blob property "Content Type".
        If the parameter is left empty, the commandlet will try to automatically determined the value based on the file's extension.
        If the parameter is left empty and the value cannot be automatically be determined, Azure storage will automatically assign "application/octet-stream" as the content type.
        Valid media type values can be found here: https://www.iana.org/assignments/media-types/media-types.xhtml
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the file in the container if it already exists
        
    .PARAMETER DeleteOnUpload
        Switch to tell the cmdlet if you want the local file to be deleted after the upload completes
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageUpload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Filepath "c:\temp\bacpac\UAT_20180701.bacpac" -DeleteOnUpload
        
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
        PS C:\> Invoke-D365AzureStorageUpload -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Filepath "c:\temp\bacpac\UAT_20180701.bacpac" -DeleteOnUpload
        
        This will upload the "c:\temp\bacpac\UAT_20180701.bacpac" up to the "backupfiles" container, inside the "miscfiles" Azure Storage Account.
        A SAS key is used to gain access to the container and uploading the file to it.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Bacpac, Container
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Invoke-D365AzureStorageUpload {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false)]
        [string] $AccountId = $Script:AzureStorageAccountId,

        [Parameter(Mandatory = $false)]
        [string] $AccessToken = $Script:AzureStorageAccessToken,

        [Parameter(Mandatory = $false)]
        [string] $SAS = $Script:AzureStorageSAS,

        [Parameter(Mandatory = $false)]
        [Alias('Blob')]
        [Alias('Blobname')]
        [string] $Container = $Script:AzureStorageContainer,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipeline = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true)]
        [Alias('File')]
        [Alias('Path')]
        [string] $Filepath,

        [Parameter(Mandatory = $false)]
        [string] $ContentType,

        [switch] $Force,

        [switch] $DeleteOnUpload,

        [switch] $EnableException
    )
    BEGIN {
        if (([string]::IsNullOrEmpty($AccountId) -eq $true) -or
            ([string]::IsNullOrEmpty($Container)) -or
            (([string]::IsNullOrEmpty($AccessToken)) -and ([string]::IsNullOrEmpty($SAS)))) {
            Write-PSFMessage -Level Host -Message "It seems that you are missing some of the parameters. Please make sure that you either supplied them or have the right configuration saved."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }
    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }

        Invoke-TimeSignal -Start

        $FileName = Split-Path -Path $Filepath -Leaf
        try {

            if ([string]::IsNullOrEmpty($SAS)) {
                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with AccessToken"

                $storageContext = New-AzStorageContext -StorageAccountName $AccountId.ToLower() -StorageAccountKey $AccessToken
            }
            else {
                $conString = $("BlobEndpoint=https://{0}.blob.core.windows.net/;QueueEndpoint=https://{0}.queue.core.windows.net/;FileEndpoint=https://{0}.file.core.windows.net/;TableEndpoint=https://{0}.table.core.windows.net/;SharedAccessSignature={1}" -f $AccountId.ToLower(), $SAS)

                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with SAS" -Target $conString
                
                $storageContext = New-AzStorageContext -ConnectionString $conString
            }

            Write-PSFMessage -Level Verbose -Message "Start uploading the file to Azure"

            if ([string]::IsNullOrEmpty($ContentType)) {
                $ContentType = [System.Web.MimeMapping]::GetMimeMapping($Filepath) # Available since .NET4.5, so it can be used with PowerShell 5.0 and higher.

                Write-PSFMessage -Level Verbose -Message "Content Type is automatically set to value: $ContentType"
            }

            $null = Set-AzStorageBlobContent -Context $storageContext -File $Filepath -Container $($Container.ToLower()) -Properties @{"ContentType" = $ContentType} -Force:$Force

            if ($DeleteOnUpload) {
                Remove-Item $Filepath -Force
            }

            [PSCustomObject]@{
                File     = $Filepath
                Filename = $FileName
            }
        }
        catch {
            $messageString = "Something went wrong while <c='em'>uploading</c> the file to Azure."
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $FileName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }
        finally {
            Invoke-TimeSignal -End
        }
    }

    END { }
}