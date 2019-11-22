
<#
    .SYNOPSIS
        Download SqlPackage.exe to your machine
        
    .DESCRIPTION
        Download and extract the DotNet/.NET core x64 edition of the SqlPackage.exe to your machine
        
    .PARAMETER Url
        Url/Uri to where the latest SqlPackage download is located
        
        The default value is for v18.4 as of writing
        
    .PARAMETER Path
        Path to where you want the SqlPackage to be extracted to
        
        Default value is: "C:\temp\d365fo.tools\SqlPackage\SqlPackage.exe"
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage -Path "C:\temp\d365fo.tools\SqlPackage"
        
        This will update the path for the SqlPackage.exe in the modules configuration
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365InstallSqlPackage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $Url = "https://go.microsoft.com/fwlink/?linkid=2109019",

        [string] $Path = "C:\temp\d365fo.tools\SqlPackage"
    )

    $sqlPackageFolder = $Path
    $downloadPath = Join-Path -Path $sqlPackageFolder -ChildPath "SqlPackage.zip"

    if (-not (Test-PathExists -Path $sqlPackageFolder -Type Container -Create)) { return }

    if (Test-PSFFunctionInterrupt) { return }

    Write-PSFMessage -Level Verbose -Message "Downloading SqlPackage.zip from the internet. $($Url)" -Target $Url
    (New-Object System.Net.WebClient).DownloadFile($Url, $downloadPath)

    if (-not (Test-PathExists -Path $downloadPath -Type Leaf)) { return }

    Unblock-File -Path $downloadPath

    $tempExtractPath = Join-Path -Path $sqlPackageFolder -ChildPath "Temp"

    Expand-Archive -Path $downloadPath -DestinationPath $tempExtractPath -Force

    Get-ChildItem -Path $tempExtractPath | Move-Item -Destination {$_.Directory.Parent.FullName}

    $tempExtractPath | Remove-Item -Force -Recurse
    $downloadPath | Remove-Item -Force -Recurse

    Set-D365SqlPackagePath $(Join-Path -Path $Path -ChildPath "SqlPackage.exe")
}