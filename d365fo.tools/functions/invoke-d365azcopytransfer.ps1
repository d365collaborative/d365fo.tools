
<#
    .SYNOPSIS
        Transfer a file using AzCopy
        
    .DESCRIPTION
        Transfer a file using the AzCopy tool
        
        You can upload a local file to an Azure Storage Blob Container
        
        You can download a file located in an Azure Storage Blob Container to a local folder
        
        You can transfer a file located in an Azure Storage Blob Container to another Azure Storage Blob Container, across regions and subscriptions, if you have SAS tokens/keys as part of your uri
        
    .PARAMETER SourceUri
        Source file uri that you want to transfer
        
    .PARAMETER DestinationUri
        Destination file uri that you want to transfer the file to
        
    .PARAMETER FileName
        You might only pass a blob container or folder name in the DestinationUri parameter and want to give the transfered file another name than the original file name
        
    .PARAMETER DeleteOnTransferComplete
        Instruct the cmdlet to delete the source file when done transfering
        
        Default is $false which will leave the source file
        
    .PARAMETER LogPath
        The path where the log file(s) will be saved
        
        When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite already existing file
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365AzCopyTransfer -SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=..." -DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac"
        
        This will transfer a file from an Azure Storage Blob Container to a local folder/file on the machine.
        The file that will be transfered/downloaded is SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".
        The file will be transfered/downloaded to DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac".
        
        If there exists a file already, the file will NOT be overwritten.
        
    .EXAMPLE
        PS C:\> Invoke-D365AzCopyTransfer -SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=..." -DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac" -Force
        
        This will transfer a file from an Azure Storage Blob Container to a local folder/file on the machine.
        The file that will be transfered/downloaded is SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".
        The file will be transfered/downloaded to DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac".
        If there exists a file already, the file will  be overwritten, because Force has been supplied.
        
    .EXAMPLE
        PS C:\> Invoke-D365AzCopyTransfer -SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=..." -DestinationUri "https://456.blob.core.windows.net/targetcontainer/filename?sv=2015-12-11&sr=..."
        
        This will transfer a file from an Azure Storage Blob Container to another Azure Storage Blob Container.
        The file that will be transfered/downloaded is SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".
        The file will be transfered/downloaded to DestinationUri "https://456.blob.core.windows.net/targetcontainer/filename?sv=2015-12-11&sr=...".
        
        For this to work, you need to make sure both SourceUri and DestinationUri has an valid SAS token/key included.
        
        If there exists a file already, the file will NOT be overwritten.
        
    .EXAMPLE
        PS C:\> Invoke-D365AzCopyTransfer -SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=..." -DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac" -DeleteOnTransferComplete
        
        This will transfer a file from an Azure Storage Blob Container to a local folder/file on the machine.
        The file that will be transfered/downloaded is SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".
        The file will be transfered/downloaded to DestinationUri "c:\temp\d365fo.tools\GOLDER.bacpac".
        
        After the file has been transfered to your local "c:\temp\d365fo.tools\GOLDER.bacpac", it will be deleted from the SourceUri "https://123.blob.core.windows.net/containername/filename?sv=2015-12-11&sr=...".
        
    .EXAMPLE
        PS C:\> $DestinationParms = Get-D365AzureStorageUrl -OutputAsHashtable
        PS C:\> $BlobFileDetails = Get-D365LcsDatabaseBackups -Latest | Invoke-D365AzCopyTransfer @DestinationParms
        PS C:\> $BlobFileDetails | Invoke-D365AzCopyTransfer -DestinationUri "C:\Temp" -DeleteOnTransferComplete
        
        This will transfer the lastest backup file from LCS Asset Library to your local "C:\Temp".
        It will get a destination Url, for it to transfer the backup file between the LCS storage account and your own.
        The newly transfered file, that lives in your own storage account, will then be downloaded to your local "c:\Temp".
        
        After the file has been downloaded to your local "C:\Temp", it will be deleted from your own storage account.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Latest, Bacpac, Container, LCS, Asset, Library
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Invoke-D365AzCopyTransfer {
    [CmdletBinding()]
    param (
        [Alias('SourceUrl')]
        [Alias('FileLocation')]
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $SourceUri,

        [Alias('DestinationFile')]
        [Parameter(Mandatory = $true)]
        [string] $DestinationUri,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $FileName,

        [switch] $DeleteOnTransferComplete,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\AzCopy"),

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly,

        [switch] $Force,

        [switch] $EnableException
    )

    process {
        $executable = $Script:AzCopyPath

        Invoke-TimeSignal -Start

        if (-not [string]::IsNullOrEmpty($FileName)) {
            if ($DestinationUri -like "*?*") {
                $DestinationUri = $DestinationUri.Replace("?", "/$FileName`?")
            }
            else {
                if ([System.IO.File]::GetAttributes($DestinationUri).HasFlag([System.IO.FileAttributes]::Directory)) {
                    $DestinationUri = Join-Path -Path $DestinationUri -ChildPath $FileName
                }
            }
        }

        $params = New-Object System.Collections.Generic.List[string]

        $params.Add("copy")
        $params.Add("`"$SourceUri`"")
        $params.Add("`"$DestinationUri`"")

        if (-not $Force) {
            $params.Add("--overwrite=false")
        }

        Invoke-Process -Executable $executable -Params $params.ToArray() -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath

        if (Test-PSFFunctionInterrupt) { return }

        if ($DeleteOnTransferComplete) {

            $params = New-Object System.Collections.Generic.List[string]

            $params.Add("remove")
            $params.Add("`"$SourceUri`"")

            Invoke-Process -Executable $executable -Params $params.ToArray() -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly
        }

        if ($DestinationUri -notlike "*https*") {
            $filePath = Get-ChildItem -Path $DestinationUri -Recurse -File | Sort-Object CreationTime -Descending | Select-Object -First 1
            $FileName = $filePath.Name
        }
        else {
            $filePath = $DestinationUri
        }

        #Filename is missing. If Https / SAS, we need some work.
        #If local file, it should be easy to solve
        $res = @{
            File       = $filePath
            SourceUri  = $filePath
            PSTypeName = 'D365FO.TOOLS.AZCOPYTRANSFER'
        }

        if (-not [string]::IsNullOrEmpty($FileName)) {
            $res.FileName = $FileName
        }

        [PSCustomObject]$res

        Invoke-TimeSignal -End
    }
}