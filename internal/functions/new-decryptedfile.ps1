function New-DecryptedFile ($File,$DropPath)
{
    if ( (Test-Path $File) -eq $false) {
        throw [System.IO.FileNotFoundException] "$File not found."
    }

    $fileInfo = [System.IO.FileInfo]::new($File)
    
    $DropFile = Join-Path $DropPath  $FileInfo.Name
    Write-Verbose "Dropfile $DropFile"

    Copy-Item $File $DropFile -Force

    if (Test-Path $DropFile.Trim()) {

        Write-Verbose "Decrypting the $DropFile"
        $Decrypter = Join-Path  $AosServiceWebRootPath -ChildPath "bin\Microsoft.Dynamics.AX.Framework.ConfigEncryptor.exe"
        & $Decrypter -decrypt $DropFile
    }
}