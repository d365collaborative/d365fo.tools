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

.EXAMPLE
Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles"

Will get all files in the blob / container

.EXAMPLE
Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Blobname "backupfiles" -Name "*UAT*"

Will get all files in the blob / container that fits the "*UAT*" search value

.NOTES

#>
function Get-D365AzureStorageFile {
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

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )] 
        [string] $Name = "*"
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

    PROCESS {    $storageContext = new-AzureStorageContext -StorageAccountName $AccountId -StorageAccountKey $AccessToken

        $cloudStorageAccount = [Microsoft.WindowsAzure.Storage.CloudStorageAccount]::Parse($storageContext.ConnectionString)

        $blobClient = $cloudStorageAccount.CreateCloudBlobClient()

        $blobcontainer = $blobClient.GetContainerReference($Blobname);

        try {
            $files = $blobcontainer.ListBlobs()

            foreach ($obj in $files) {
                if ($obj.Name -NotLike $Name) { continue }

                $obj
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