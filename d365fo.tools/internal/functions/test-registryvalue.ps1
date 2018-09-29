Function Test-RegistryValue {
    [OutputType([System.Boolean])]
    param([string]$Path, [string]$Name)
    if (Test-Path -Path $Path -PathType Any) {
        $null -ne (Get-ItemProperty $Path).$Name 
    }
    else {
        $false
    }
}