function Rename-ConfigValue($File, $NewValue, $OldValue) {
    (Get-Content $File).replace($OldValue, $NewValue) | Set-Content $File
}