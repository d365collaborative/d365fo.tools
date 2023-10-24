
<#
    .SYNOPSIS
        Download SqlPackage.exe to your machine
        
    .DESCRIPTION
        Download and extract the DotNet/.NET core x64 edition of the SqlPackage.exe to your machine
        
        It parses the raw html page and tries to extract the latest download link.
        As of 12th April 2022, no .NET Core link is available on the download page. The cmdlet will always use the Url parameter.
        
    .PARAMETER Path
        Path to where you want the SqlPackage to be extracted to
        
        Default value is: "C:\temp\d365fo.tools\SqlPackage\SqlPackage.exe"
        
    .PARAMETER SkipExtractFromPage
        Instruct the cmdlet to skip trying to parse the download page and to rely on the Url parameter only
        
    .PARAMETER Url
        Url/Uri to where the latest SqlPackage download is located
        
        The default value is for v19.1 (16.0.6161.0) as of writing. This is the last version of SqlPackage based on .NET Core.
        According to the Microsoft documentation, a .NET Core version of SqlPackage should be used.
        https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/database/import-database
        Further discussion can be found here: https://github.com/d365collaborative/d365fo.tools/issues/708
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage
        
        This will download and extract the latest SqlPackage.exe.
        It will use the default value for the Path parameter, for where to save the SqlPackage.exe.
        It will try to extract the latest download URL from the RAW html page.
        It will update the path for the SqlPackage.exe in configuration.
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage -Path "C:\temp\SqlPackage"
        
        This will download and extract the latest SqlPackage.exe.
        It will try to extract the latest download URL from the RAW html page.
        It will update the path for the SqlPackage.exe in configuration.
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage -SkipExtractFromPage
        
        This will download and extract the latest SqlPackage.exe.
        It will rely on the Url parameter to based the download from.
        It will use the default value of the Url parameter.
        It will update the path for the SqlPackage.exe in configuration.
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage -SkipExtractFromPage -Url "https://go.microsoft.com/fwlink/?linkid=3030303"
        
        This will download and extract the latest SqlPackage.exe.
        It will rely on the Url parameter to based the download from.
        It will use the "https://go.microsoft.com/fwlink/?linkid=3030303" as value for the Url parameter.
        It will update the path for the SqlPackage.exe in configuration.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365InstallSqlPackage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $Path = "C:\temp\d365fo.tools\SqlPackage",

        [switch] $SkipExtractFromPage,

        [string] $Url = "https://go.microsoft.com/fwlink/?linkid=2196334"
    )

    if (-not $SkipExtractFromPage) {
        $content = (Invoke-WebRequest -Uri "https://learn.microsoft.com/en-us/sql/tools/sqlpackage-download" -UseBasicParsing).content
        $res = $content -match '<td.*>Windows .NET Core<.*/td>\s*<td.*><a href="(https://.*)" .*'
        
        if ($res) {
            $Url = ([string]$Matches[1]).Trim()
        }
        else {
            Write-PSFMessage -Level Host -Message "Parsing the web page didn't succeed. Will fall back to the download url." -Target "https://learn.microsoft.com/en-us/sql/tools/sqlpackage-download"
        }
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

    Set-D365SqlPackagePath -Path $(Join-Path -Path $Path -ChildPath "SqlPackage.exe")
}