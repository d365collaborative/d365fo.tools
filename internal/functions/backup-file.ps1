function Backup-File($File, $BackupExtension) {
    $FileBackup = Get-BackupName $File $BackupExtension
    (Get-Content -Path $File) | Set-Content -path $FileBackup
}