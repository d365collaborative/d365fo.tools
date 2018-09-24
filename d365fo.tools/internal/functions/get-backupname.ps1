
function Get-BackupName($File, $Backup) {
    write-verbose $File
    $FileInfo = [System.IO.FileInfo]::new($File)
    $BackupName = "{0}{1}_{2}{3}" -f $FileInfo.Directory, $FileInfo.BaseName, $Backup, $FileInfo.Extension
    Write-Verbose "Backupname will be $BackupName"
    $BackupName
}