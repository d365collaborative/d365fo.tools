function Rename-ConfigValue($File, $NewValue, $OldValue) {
    Write-PSFMessage -Level Verbose -Message "Replace content from $File. Old value is $OldValue. New valee is $NewValue." -Target (@($File, $OldValue, $NewValue))
    (Get-Content $File).replace($OldValue, $NewValue) | Set-Content $File
}