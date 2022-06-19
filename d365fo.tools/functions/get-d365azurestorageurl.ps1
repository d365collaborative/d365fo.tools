
<#
    .SYNOPSIS
        Get a blob Url from Azure Storage account
        
    .DESCRIPTION
        Get a valid blob container url from an Azure Storage Account
        
    .PARAMETER AccountId
        Storage Account Name / Storage Account Id you want to work against
        
    .PARAMETER SAS
        The SAS key that you have created for the storage account or blob container
        
    .PARAMETER Container
        Name of the blob container inside the storage account you want to work against
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hastable object
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageUrl -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles"
        
        This will generate a valid Url for the blob container in the Azure Storage Account.
        It will use the AccountId "miscfiles" as the name of the storage account.
        It will use the SAS key "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" to add the SAS token/key to the Url.
        It will use the Container "backupfiles" as the container name in the Url.
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageUrl
        
        This will generate a valid Url for the blob container in the Azure Storage Account.
        It will use the default values that are configured using the Set-D365ActiveAzureStorageConfig cmdlet and view using the Get-D365ActiveAzureStorageConfig cmdlet.
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageUrl -OutputAsHashtable
        
        This will generate a valid Url for the blob container in the Azure Storage Account.
        It will use the default values that are configured using the Set-D365ActiveAzureStorageConfig cmdlet and view using the Get-D365ActiveAzureStorageConfig cmdlet.
        
        The output object will be a Hashtable, which you can use as a parameter for other cmdlets.
        
    .EXAMPLE
        PS C:\> $DestinationParms = Get-D365AzureStorageUrl -OutputAsHashtable
        PS C:\> $BlobFileDetails = Get-D365LcsDatabaseBackups -Latest | Invoke-D365AzCopyTransfer @DestinationParms
        PS C:\> $BlobFileDetails | Invoke-D365AzCopyTransfer -DestinationUri "C:\Temp" -DeleteOnTransferComplete
        
        This will transfer the lastest backup file from LCS Asset Library to your local "C:\Temp".
        It will get a destination Url, for it to transfer the backup file between the LCS storage account and your own.
        The newly transfered file, that lives in your own storage account, will then be downloaded to your local "c:\Temp".
        
        After the file has been downloaded to your local "C:\Temp", it will be deleted from your own storage account.
        
    .NOTES
        Tags: Azure, Azure Storage, Token, Blob, File, Container, LCS, Asset, Bacpac, Backup
        
        Author: Mötz Jensen (@Splaxi)
#>
function Get-D365AzureStorageUrl {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    [CmdletBinding()]
    param (
        [string] $AccountId = $Script:AzureStorageAccountId,

        [string] $SAS = $Script:AzureStorageSAS,

        [Alias('Blob')]
        [Alias('Blobname')]
        [string] $Container = $Script:AzureStorageContainer,

        [switch] $OutputAsHashtable
    )

    if (([string]::IsNullOrEmpty($AccountId) -eq $true) -or
        ([string]::IsNullOrEmpty($Container)) -or
        ([string]::IsNullOrEmpty($SAS))) {
        Write-PSFMessage -Level Host -Message "It seems that you are missing some of the parameters. Please make sure that you either supplied them or have the right configuration saved."
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    Invoke-TimeSignal -Start

    if ($SAS.StartsWith("?")) {
        $SAS = $SAS.Substring(1)
    }

    $res = @{
        DestinationUri = $("https://{0}.blob.core.windows.net/{1}?{2}" -f $AccountId.ToLower(), $Container, $SAS)
    }

    if ($OutputAsHashtable) {
        $res
    }
    else {
        [PSCustomObject]$res
    }

    Invoke-TimeSignal -End
}