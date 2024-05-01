
<#
    .SYNOPSIS
        Download SqlPackage.exe to your machine
        
    .DESCRIPTION
        Download and extract SqlPackage.exe to your machine.
        
    .PARAMETER Path
        Path to where you want the SqlPackage to be extracted to
        
        Default value is: "C:\temp\d365fo.tools\SqlPackage\SqlPackage.exe"
        
    .PARAMETER Latest
        Overrides the Url parameter and uses the latest download URL provided by the evergreen link https://aka.ms/sqlpackage-windows
        
    .PARAMETER Url
        Url/Uri to where the SqlPackage download is located
        
        The default value is for version 162.2.111.2 as of writing.
        
        Further discussion can be found here: https://github.com/d365collaborative/d365fo.tools/discussions/816
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage
        
        This will download and extract SqlPackage.exe.
        It will use the default value for the Path parameter, for where to save the SqlPackage.exe.
        It will update the path for the SqlPackage.exe in configuration.
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage -Path "C:\temp\SqlPackage"
        
        This will download and extract SqlPackage.exe.
        It will save the SqlPackage.exe to "C:\temp\SqlPackage".
        It will update the path for the SqlPackage.exe in configuration.
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage -Latest
        
        This will download and extract the latest SqlPackage.exe.
        It will use https://aka.ms/sqlpackage-windows as the download URL.
        It will update the path for the SqlPackage.exe in configuration.
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage -Url "https://go.microsoft.com/fwlink/?linkid=3030303"
        
        This will download and extract SqlPackage.exe.
        It will rely on the Url parameter to base the download on.
        It will use the "https://go.microsoft.com/fwlink/?linkid=3030303" as value for the Url parameter.
        It will update the path for the SqlPackage.exe in configuration.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        Author: Florian Hopfner (@FH-Inway)
#>

function Invoke-D365InstallSqlPackage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding(DefaultParameterSetName = 'ImportUrl')]
    [OutputType()]
    param (
        [Parameter(ParameterSetName = 'ImportUrl')]
        [Parameter(ParameterSetName = 'ImportLatest')]
        [string] $Path = "C:\temp\d365fo.tools\SqlPackage",
        
        [Parameter(ParameterSetName = 'ImportLatest')]
        [switch] $Latest,
        
        [Parameter(ParameterSetName = 'ImportUrl')]
        [string] $Url = "https://go.microsoft.com/fwlink/?linkid=2261576"
    )

    if ($Latest) {
        $Url = "https://aka.ms/sqlpackage-windows"
    }

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

    Get-ChildItem -Path $tempExtractPath | Move-Item -Destination { $_.Directory.Parent.FullName } -Force

    $tempExtractPath | Remove-Item -Force -Recurse
    $downloadPath | Remove-Item -Force -Recurse

    $SqlPackagePath = Join-Path -Path $Path -ChildPath "SqlPackage.exe"
    Set-D365SqlPackagePath -Path $SqlPackagePath

    $result = Invoke-Process -Path $SqlPackagePath -Params "/Version" 
    $version = $result.stdout -replace "`r`n", ""

    Write-PSFMessage -Level Host -Message "SqlPackage.exe version $version has been downloaded and extracted to $SqlPackagePath"
}