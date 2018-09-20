function Backup-File($File, $BackupExtension) {
    $FileBackup = Get-BackupName $File $BackupExtension
    Write-PSFMessage -Level Verbose -Message "Backing up $File to $FileBackup" -Target (@($File, $FileBackup))
    (Get-Content -Path $File) | Set-Content -path $FileBackup
}