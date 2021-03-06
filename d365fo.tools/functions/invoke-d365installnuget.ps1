
<#
    .SYNOPSIS
        Download nuget.exe to your machine
        
    .DESCRIPTION
        Download the nuget.exe to your machine
        
        By default it will download the latest version
        
    .PARAMETER Path
        Path to where you want the nuget.exe to be downloaded to
        
        Default value is: "C:\temp\d365fo.tools\nuget\nuget.exe"
        
    .PARAMETER Url
        Url/Uri to where the latest nuget download is located
        
        The default value is "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallNuget
        
        This will download the latest version of nuget.
        The install path is identified by the default value: "C:\temp\d365fo.tools\nuget\nuget.exe".
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>
function Invoke-D365InstallNuget {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $Path = "C:\temp\d365fo.tools\nuget",

        [string] $Url = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
    )

    $downloadPath = Join-Path -Path $Path -ChildPath "nuget.exe"

    if (-not (Test-PathExists -Path $Path -Type Container -Create)) { return }

    if (Test-PSFFunctionInterrupt) { return }

    Write-PSFMessage -Level Verbose -Message "Downloading nuget.exe from the internet. $($Url)" -Target $Url
    (New-Object System.Net.WebClient).DownloadFile($Url, $downloadPath)

    if (-not (Test-PathExists -Path $downloadPath -Type Leaf)) { return }

    Unblock-File -Path $downloadPath

    Set-D365NugetPath -Path $downloadPath
}