﻿
<#
    .SYNOPSIS
        Get file information from Azure Storage
        
    .DESCRIPTION
        Get information for files from an Azure Storage Account
        
    .PARAMETER AccountId
        Storage Account Name / Storage Account Id where file information should be retrieved from
        
    .PARAMETER AccessToken
        The token that has the needed permissions for the search action
        
    .PARAMETER SAS
        The SAS key for the storage account or blob container
        
    .PARAMETER Container
        Name of the blob container inside the storage account where file information should be retrieved from
        
    .PARAMETER Name
        Name of the files information should be retrieved for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all files
        
    .PARAMETER Latest
        Instruct the cmdlet to only fetch the information of the latest file from the Azure Storage Account
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles"
        
        This will get information for all files in the blob container "backupfiles".
        It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access.
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Latest
        
        This will get information for the latest (newest) file from the blob container "backupfiles".
        It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access to the container.
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Name "*UAT*"
        
        This will get information for all files in the blob container "backupfiles" that fits the "*UAT*" search value.
        It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access to the container.
        
    .EXAMPLE
        PS C:\> Get-D365AzureStorageFile -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Latest
        
        This will get information for the latest (newest) file from the blob container "backupfiles".
        It will use the SAS key "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" to gain access to the container.
        
    .NOTES
        Tags: Azure, Azure Storage, Token, Blob, File, Container
        
        Author: Mötz Jensen (@Splaxi)
        Author: Florian Hopfner (@FH-Inway)
#>
function Get-D365AzureStorageFile {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [string] $AccountId = $Script:AzureStorageAccountId,

        [string] $AccessToken = $Script:AzureStorageAccessToken,

        [string] $SAS = $Script:AzureStorageSAS,

        [Alias('Blob')]
        [Alias('Blobname')]
        [string] $Container = $Script:AzureStorageContainer,

        [Parameter(ParameterSetName = 'Default')]
        [Alias('FileName')]
        [string] $Name = "*",

        [Parameter(Mandatory = $true, ParameterSetName = 'Latest')]
        [Alias('GetLatest')]
        [switch] $Latest
    )

    $connectionInformation = ($AccountId -and $Container)
    $authenticationInformation = ($AccessToken -or $SAS)
    if (-not ($connectionInformation -and $authenticationInformation)) {
        Write-PSFMessage -Level Host -Message "It seems that you are missing some of the parameters. Please make sure that you either supplied them or have the right configuration saved."
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    Invoke-TimeSignal -Start

    if ([string]::IsNullOrEmpty($SAS)) {
        Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with AccessToken"

        $storageContext = New-AzStorageContext -StorageAccountName $AccountId.ToLower() -StorageAccountKey $AccessToken
    }
    else {
        Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with SAS"

        $conString = $("BlobEndpoint=https://{0}.blob.core.windows.net/;QueueEndpoint=https://{0}.queue.core.windows.net/;FileEndpoint=https://{0}.file.core.windows.net/;TableEndpoint=https://{0}.table.core.windows.net/;SharedAccessSignature={1}" -f $AccountId.ToLower(), $SAS)
        $storageContext = New-AzStorageContext -ConnectionString $conString
    }

    try {
        $files = Get-AzStorageBlob -Container $($Container.ToLower()) -Context $storageContext |
            Sort-Object -Descending { $_.LastModified }

        $selectParams = @{
            TypeName = "D365FO.TOOLS.Azure.Blob"
            Property = "Name", "Length as Size to PSFSize", "LastModified"
        }
        if ($Latest) {
            $files |
                Select-Object -First 1 |
                Select-PSFObject @selectParams
        }
        else {
            $filteredFiles = $files | Where-Object { $_.Name -Like $Name }
            foreach ($fileInfo in $filteredFiles) {
                $fileInfo | Select-PSFObject @selectParams
            }
        }
    }
    catch {
        Write-PSFMessage -Level Warning -Message "Something broke" -ErrorRecord $_
    }

    Invoke-TimeSignal -End
}