
<#
    .SYNOPSIS
        Backup a file
        
    .DESCRIPTION
        Backup a file either in the same directory as the original file with a suffix or in a different directory.
        
    .PARAMETER File
        Path to the file that you want to backup
        
    .PARAMETER Suffix
        The suffix value that you want to append to the file name when backing it up in the same directory.
        
    .PARAMETER DestinationPath
        Path to the folder where you want the backup file to be placed. This parameter is used when you want to backup the file in a different directory.
        
    .PARAMETER Force
        Instructs the cmdlet to overwrite an already existing backup of the file.
        
    .EXAMPLE
        PS C:\> Backup-File -File c:\temp\d365fo.tools\test.txt -Suffix "Original"
        
        This will backup the "test.txt" file as "test_Original.txt" inside "c:\temp\d365fo.tools\"
        
    .EXAMPLE
        PS C:\> Backup-File -File c:\temp\d365fo.tools\test.txt -Suffix "Original" -Force
        
        This will backup the "test.txt" file as "test_Original.txt" inside "c:\temp\d365fo.tools\"
        If the file already exists in the destination folder, it will be overwritten.
        
    .EXAMPLE
        PS C:\> Backup-File -File c:\temp\d365fo.tools\test.txt -DestinationPath c:\temp\d365fo.tools\backup
        
        This will backup the "test.txt" file to "c:\temp\d365fo.tools\backup\test.txt"
        
    .EXAMPLE
        PS C:\> Backup-File -File c:\temp\d365fo.tools\test.txt -DestinationPath c:\temp\d365fo.tools\backup -Force
        
        This will backup the "test.txt" file to "c:\temp\d365fo.tools\backup\test.txt"
        If the file already exists in the destination folder, it will be overwritten.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        Author: Florian Hopfner (@FH-Inway)
        
#>
function Backup-File {
    [CmdletBinding(
        DefaultParameterSetName = "SameFolderWithSuffix")]
    param (
        [Parameter(Mandatory = $true)]
        [string] $File,
        
        [Parameter(Mandatory = $true, ParameterSetName = "SameFolderWithSuffix")]
        [string] $Suffix,

        [Parameter(Mandatory = $true, ParameterSetName = "DifferentFolder")]
        [string] $DestinationPath,

        [switch] $Force
    )

    begin {
        if (-not (Test-PathExists -Path $File -Type Leaf)) { return }
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq "SameFolderWithSuffix") {
            $FileBackup = Get-BackupName -File $File -Suffix $Suffix
        }
        elseif ($PSCmdlet.ParameterSetName -eq "DifferentFolder") {
            $FileName = Split-Path -Path $File -Leaf
            $FileBackup = Join-Path -Path $DestinationPath -ChildPath $FileName
        }

        Write-PSFMessage -Level Verbose -Message "Backing up $File to $FileBackup" -Target (@($File, $FileBackup))

        if (-not $Force) {
            if (Test-PathExists -Path $FileBackup -Type Leaf -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$FileBackup</c> already exists. Consider changing the <c='em'>destination</c> path or set the <c='em'>Force</c> parameter to overwrite the file."
                return
            }
        }

        Copy-Item -Path $File -Destination $FileBackup -Force:$Force -PassThru | Select-PSFObject "Name as Filename", "LastWriteTime as LastModified", "Fullname as File"
    }
    
}