Function Test-RegistryValue {
    param([string]$Path, [string]$Name)
    if (Test-Path -Path $Path -PathType Any) {
        (Get-ItemProperty $Path).$Name -ne $null
    }
    else {
        $false
    }
}