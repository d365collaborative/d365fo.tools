
<#
    .SYNOPSIS
        Create a backup of the Metadata directory
        
    .DESCRIPTION
        Creates a backup of all the files and folders from the Metadata directory
        
    .PARAMETER MetaDataDir
        Path to the Metadata directory
        
        Default value is the PackagesLocalDirectory
        
    .PARAMETER BackupDir
        Path where you want the backup to be place
        
    .EXAMPLE
        PS C:\> Backup-D365MetaDataDir
        
        This will backup the PackagesLocalDirectory and create an PackagesLocalDirectory_backup next to it
        
    .NOTES
        Tags: PackagesLocalDirectory, MetaData, MetaDataDir, MeteDataDirectory, Backup, Development
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Backup-D365MetaDataDir {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $BackupDir = "$($Script:MetaDataDir)_backup"
        
    )

    if (!(Test-Path -Path $MetaDataDir -Type Container)) {
        Write-PSFMessage -Level Host -Message "The <c='em'>$MetaDataDir</c> path wasn't found. Please ensure the path <c='em'>exists </c> and you have enough <c='em'>permission/c> to access the directory."
        Stop-PSFFunction -Message "Stopping because the path is missing."
        return
    }

    Invoke-TimeSignal -Start

    $Params = @($MetaDataDir, $BackupDir, "/MT:4", "/E", "/NFL",
        "/NDL", "/NJH", "/NC", "/NS", "/NP")

    #! We should consider to redirect the standard output & error like this: https://stackoverflow.com/questions/8761888/capturing-standard-out-and-error-with-start-process
    #Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly
    Start-Process -FilePath "Robocopy.exe" -ArgumentList $Params -NoNewWindow -Wait

    Invoke-TimeSignal -End
}