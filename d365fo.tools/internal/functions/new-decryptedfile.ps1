function New-DecryptedFile ($File, $DropPath) {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    
    $Decrypter = Join-Path  $AosServiceWebRootPath -ChildPath "bin\Microsoft.Dynamics.AX.Framework.ConfigEncryptor.exe"

    if (!(Test-PathExists -Path $Decrypter -Type Leaf)) {return}

    $fileInfo = [System.IO.FileInfo]::new($File)
    $DropFile = Join-Path $DropPath $FileInfo.Name
    
    Write-PSFMessage -Level Verbose -Message "Extracted file path is: $DropFile" -Target $DropFile
    Copy-Item $File $DropFile -Force -ErrorAction Stop

    if (!(Test-PathExists -Path $DropFile -Type Leaf)) {return}

    Write-Verbose "Decrypting the $DropFile"
    
    & $Decrypter -decrypt $DropFile
}