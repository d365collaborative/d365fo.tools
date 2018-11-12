
<#
    .SYNOPSIS
        Get a file from Azure
        
    .DESCRIPTION
        Get all files from an Azure Storage Account
        
    .PARAMETER AccountId
        Storage Account Name / Storage Account Id where you want to look for files
        
    .PARAMETER AccessToken
        The token that has the needed permissions for the search action
        
    .PARAMETER Blobname
        Name of the container / blog inside the storage account you want to look for files
        
    .PARAMETER Name
        Name of the file you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all packages
        
    .PARAMETER GetLatest
        Switch to instruct the cmdlet to only fetch the latest file from the Azure Storage Account
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles"
        
        Will get all files in the blob / container
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Name "*UAT*"
        
        Will get all files in the blob / container that fits the "*UAT*" search value
        
    .NOTES
        Tags: Azure, Azure Storage, Token, Blob, File
        
        Author: Mötz Jensen (@Splaxi)
#>
function Get-D365AzureStorageFile {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, Position = 1 )]
        [string] $AccountId = $Script:AccountId,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $AccessToken = $Script:AccessToken,

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $Blobname = $Script:Blobname,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [string] $Name = "*",

        [switch] $GetLatest
    )

    BEGIN {
        if (([string]::IsNullOrEmpty($AccountId)) -or
            ([string]::IsNullOrEmpty($AccessToken)) -or ([string]::IsNullOrEmpty($Blobname))) {
            Write-PSFMessage -Level Host -Message "It seems that you are missing some of the parameters. Please make sure that you either supplied them or have the right configuration saved."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }


    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }

        $storageContext = new-AzureStorageContext -StorageAccountName $AccountId -StorageAccountKey $AccessToken

        $cloudStorageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($storageContext.ConnectionString)

        $blobClient = $cloudStorageAccount.CreateCloudBlobClient()

        $blobcontainer = $blobClient.GetContainerReference($Blobname);

        try {
            $files = $blobcontainer.ListBlobs() | Sort-Object -Descending { $_.Properties.LastModified }

            if ($GetLatest) {
                $files | Select-Object -First 1
            }
            else {
    
                foreach ($obj in $files) {
                    if ($obj.Name -NotLike $Name) { continue }

                    $obj
                }
            }
        }
        catch {
            Write-PSFMessage -Level Warning -Message "Something broke" -ErrorRecord $_
        }
    }
    END {}
}