
<#
    .SYNOPSIS
        Decrypt web.config file
        
    .DESCRIPTION
        Utilize the built in encryptor utility to decrypt the web.config file from inside the AOS
        
    .PARAMETER File
        Path to the file that you want to work against
        
        Please be careful not to point to the original file from inside the AOS directory
        
    .PARAMETER DropPath
        Path to the directory where you want save the file after decryption is completed
        
    .EXAMPLE
        PS C:\> New-DecryptedFile -File "C:\temp\d365fo.tools\web.config" -DropPath "c:\temp\d365fo.tools\decrypted.config"
        
        This will take the "C:\temp\d365fo.tools\web.config" and decrypt it.
        After decryption the output file will be stored in "c:\temp\d365fo.tools\decrypted.config".
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function New-DecryptedFile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    Param (
        [string] $File,
        
        [string] $DropPath
    )
    
    $Decrypter = Join-Path  $AosServiceWebRootPath -ChildPath "bin\Microsoft.Dynamics.AX.Framework.ConfigEncryptor.exe"

    if (-not (Test-PathExists -Path $Decrypter -Type Leaf)) { return }

    $fileInfo = [System.IO.FileInfo]::new($File)
    $DropFile = Join-Path $DropPath $FileInfo.Name
    
    Write-PSFMessage -Level Verbose -Message "Extracted file path is: $DropFile" -Target $DropFile
    Copy-Item $File $DropFile -Force -ErrorAction Stop

    if (-not (Test-PathExists -Path $DropFile -Type Leaf)) { return }
    
    & $Decrypter -decrypt $DropFile
}