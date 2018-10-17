
<#
    .SYNOPSIS
        Backup a file
        
    .DESCRIPTION
        Backup a file in the same directory as the original file with a suffix
        
    .PARAMETER File
        Path to the file that you want to backup
        
    .PARAMETER Suffix
        The suffix value that you want to append to the file name when backing it up
        
    .EXAMPLE
        PS C:\> Backup-File -File c:\temp\d365fo.tools\test.txt -Suffix "Original"
        
        This will backup the "test.txt" file as "test_Original.txt" inside "c:\temp\d365fo.tools\"
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Backup-File {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $true)]
        [string] $File,
        
        [Parameter(Mandatory = $true)]
        [string] $Suffix
        )

    $FileBackup = Get-BackupName $File $Suffix
    Write-PSFMessage -Level Verbose -Message "Backing up $File to $FileBackup" -Target (@($File, $FileBackup))
    (Get-Content -Path $File) | Set-Content -path $FileBackup
}