
<#
    .SYNOPSIS
        Download AzCopy.exe to your machine
        
    .DESCRIPTION
        Download and extract the AzCopy.exe to your machine
        
    .PARAMETER Url
        Url/Uri to where the latest AzCopy download is located
        
        The default value is for v10 as of writing
        
    .PARAMETER Path
        Path to where you want the AzCopy to be extracted to
        
        Default value is: "C:\temp\d365fo.tools\AzCopy\AzCopy.exe"
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallAzCopy -Path "C:\temp\d365fo.tools\AzCopy\AzCopy.exe"
        
        This will update the path for the AzCopy.exe in the modules configuration
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365InstallAzCopy {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $Url = "https://aka.ms/downloadazcopy-v10-windows",

        [string] $Path = "C:\temp\d365fo.tools\AzCopy\AzCopy.exe"
    )

    $azCopyFolder = Split-Path $Path -Parent
    $downloadPath = Join-Path -Path $azCopyFolder -ChildPath "AzCopy.zip"

    if (-not (Test-PathExists -Path $azCopyFolder -Type Container -Create)) { return }

    if (Test-PSFFunctionInterrupt) { return }

    Write-PSFMessage -Level Verbose -Message "Downloading AzCopy.zip from the internet. $($Url)" -Target $Url
    (New-Object System.Net.WebClient).DownloadFile($Url, $downloadPath)

    if (-not (Test-PathExists -Path $downloadPath -Type Leaf)) { return }

    Unblock-File -Path $downloadPath

    $tempExtractPath = Join-Path -Path $azCopyFolder -ChildPath "Temp"

    Expand-Archive -Path $downloadPath -DestinationPath $tempExtractPath -Force

    $null = (Get-Item "$tempExtractPath\*\azcopy.exe").CopyTo($Path, $true)

    $tempExtractPath | Remove-Item -Force -Recurse
    $downloadPath | Remove-Item -Force -Recurse

    Set-D365AzCopyPath -Path $Path
}