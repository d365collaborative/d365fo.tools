
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
        
    .PARAMETER Container
        Name of the blob container inside the storage account you where the file is
        
    .PARAMETER FileName
        Name of the file that you want to download
        
    .PARAMETER Path
        Path to the folder / location you want to save the file
        
        The default path is "c:\temp\d365fo.tools"
        
    .PARAMETER Latest
        Instruct the cmdlet to download the latest file from Azure regardless of name
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the local file if it already exists
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -FileName "OriginalUAT.bacpac" -Path "c:\temp"
        
        Will download the "OriginalUAT.bacpac" file from the storage account and save it to "c:\temp\OriginalUAT.bacpac"
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Path "c:\temp" -Latest
        
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
        The complete path to the file will returned as output from the cmdlet.
        
    .EXAMPLE
        PS C:\> $AzureParams = Get-D365ActiveAzureStorageConfig
        PS C:\> Invoke-D365AzureStorageDownload @AzureParams -Path "c:\temp" -Latest
        
        This will get the current Azure Storage Account configuration details
        and use them as parameters to download the latest file from an Azure Storage Account
        
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
        The complete path to the file will returned as output from the cmdlet.
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageDownload -Latest
        
        This will use the default parameter values that are based on the configuration stored inside "Get-D365ActiveAzureStorageConfig".
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\d365fo.tools".
        
    .EXAMPLE
        PS C:\> Invoke-D365AzureStorageDownload -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Path "c:\temp" -Latest
        
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
        A SAS key is used to gain access to the container and downloading the file from it.
        The complete path to the file will returned as output from the cmdlet.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Latest, Bacpac, Container
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Invoke-D365AzureStorageDownload {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false)]
        [string] $AccountId = $Script:AzureStorageAccountId,

        [Parameter(Mandatory = $false)]
        [string] $AccessToken = $Script:AzureStorageAccessToken,

        [Parameter(Mandatory = $false)]
        [string] $SAS = $Script:AzureStorageSAS,

        [Alias('Blob')]
        [Alias('Blobname')]
        [string] $Container = $Script:AzureStorageContainer,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true)]
        [Alias('Name')]
        [string] $FileName,

        [string] $Path = $Script:DefaultTempPath,

        [Parameter(Mandatory = $true, ParameterSetName = 'Latest', Position = 4 )]
        [Alias('GetLatest')]
        [switch] $Latest,

        [switch] $Force,

        [switch] $EnableException
    )

    BEGIN {
        if (-not (Test-PathExists -Path $Path -Type Container -Create)) {
            return
        }

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

        try {

            if ([string]::IsNullOrEmpty($SAS)) {
                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with AccessToken"

                $storageContext = New-AzStorageContext -StorageAccountName $AccountId.ToLower() -StorageAccountKey $AccessToken
            }
            else {
                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with SAS"

                $conString = $("BlobEndpoint=https://{0}.blob.core.windows.net/;QueueEndpoint=https://{0}.queue.core.windows.net/;FileEndpoint=https://{0}.file.core.windows.net/;TableEndpoint=https://{0}.table.core.windows.net/;SharedAccessSignature={1}" -f $AccountId.ToLower(), $SAS)
                $storageContext = New-AzStorageContext -ConnectionString $conString
            }

            Write-PSFMessage -Level Verbose -Message "Start download from Azure Storage Account"

            if ($Latest) {
                $files = Get-AzStorageBlob -Container $($Container.ToLower()) -Context $storageContext

                $File = ($files | Sort-Object -Descending { $_.LastModified } | Select-Object -First 1)

                $FileName = $File.Name
                
                Write-PSFMessage -Level Verbose -Message "Filename is: $FileName"

                $NewFile = Join-Path $Path $($File.Name)

                $null = Get-AzStorageBlobContent -Container $($Container.ToLower()) -Blob $File.Name -Destination $NewFile -Context $storageContext -Force:$Force
            }
            else {

                Write-PSFMessage -Level Verbose -Message "Filename is: $FileName"

                $NewFile = Join-Path $Path $FileName

                $null = Get-AzStorageBlobContent -Container $($Container.ToLower()) -Blob $FileName -Destination $NewFile -Context $storageContext -Force:$Force
            }

            Get-Item -Path $NewFile | Select-PSFObject "Name as Filename", @{Name = "Size"; Expression = { [PSFSize]$_.Length } }, "LastWriteTime as LastModified", "Fullname as File"
        }
        catch {
            $messageString = "Something went wrong while <c='em'>downloading</c> the file from Azure."
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $NewFile
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }
        finally {
            Invoke-TimeSignal -End
        }
    }

    END { }
}