Function Test-RegistryValue {
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        
        [Parameter(Mandatory = $true)]
        [string]$Name
        )

    if (Test-Path -Path $Path -PathType Any) {
        $null -ne (Get-ItemProperty $Path).$Name
    }
    else {
        $false
    }
}