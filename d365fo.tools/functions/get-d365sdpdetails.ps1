
<#
    .SYNOPSIS
        Get details from the Software Deployable Package
        
    .DESCRIPTION
        Details details about the inner modules / packages that a Software Deployable Contains
        
    .PARAMETER Path
        Path to the Software Deployable Package that you want to work against
        
        The cmdlet supports a path to a zip-file or directory with the unpacked content
        
    .EXAMPLE
        PS C:\> Get-D365SDPDetails -Path 'C:\Temp\RV-10.0.36.44.zip'
        
        This will display the basic details about the package.
        The package is a zip file.
        
        A result set example:
        
        Platform PlatformVersion Modules
        -------- --------------- -------
        Update55 7.0.6651.92     {@{Name=RapidValue; Version=7.0.6651.92}, @{Name=TCLCommon; Version=7.0.6651.92}, @{Name=TC...
        
    .EXAMPLE
        PS C:\> Get-D365SDPDetails -Path 'C:\Temp\RV-10.0.36.44'
        
        This will display the basic details about the package.
        The package is extracted to a local folder.
        
        A result set example:
        
        Platform PlatformVersion Modules
        -------- --------------- -------
        Update55 7.0.6651.92     {@{Name=RapidValue; Version=7.0.6651.92}, @{Name=TCLCommon; Version=7.0.6651.92}, @{Name=TC...
        
    .EXAMPLE
        PS C:\> Get-D365SDPDetails -Path 'C:\Temp\RV-10.0.36.44.zip' | Select-Object -ExpandProperty Modules
        
        This will display the module details that are part of the package.
        The package is a zip file.
        
        A result set example:
        
        Name       Version
        ----       -------
        RapidValue 7.0.6651.92
        TCLCommon  7.0.6651.92
        TCLLabel   7.0.6651.92
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>#
function Get-D365SDPDetails {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    param (
        [Parameter(Mandatory = $True)]
        [Alias('File')]
        [string] $Path
    )

    $pathWorkDirectory = "$([System.IO.Path]::GetTempPath())d365fo.tools\$([System.Guid]::NewGuid().Guid)"
    #Make sure the work path is created and available
    New-Item -Path $pathWorkDirectory -ItemType Directory -Force -ErrorAction Ignore > $null
    $pathHotfix = Join-Path -Path $pathWorkDirectory -ChildPath "HotfixInstallationInfo.xml"

    Invoke-TimeSignal -Start

    if ($Path.EndsWith(".zip")) {
        <#
            If we have a zip file, we'll extract the files, to mimic a folder
            Will copy to the default Windows temporary folder
        #>

        Unblock-File -Path $Path

        $file = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open)
        $zipArch = [System.IO.Compression.ZipArchive]::new($file)
        $zipEntry = $zipArch.GetEntry("HotfixInstallationInfo.xml")

        if (-not $zipEntry) {
            $messageString = "Unable to find the <c='em'>HotfixInstallationInfo.xml</c> file inside the archive. It would indicate the <c='em'>$Path</c> isn't a valid software deployable package."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because HotfixInstallationInfo.xml wasn't found." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        }

        if (Test-PSFFunctionInterrupt) { return }

        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($zipEntry, $pathHotfix, $true)


        foreach ($nuget in $($zipArch.Entries | Where-Object Fullname -like "AOSService\Packages\*.nupkg")) {
            $pathNuget = "$pathWorkDirectory\$($nuget.name).zip"
            
            # The nuget file contains module name in correct casing
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($nuget, $pathNuget, $true)

        }

        # Clear out any zip archive objects from memory
        if ($zipArch) {
            $zipArch.Dispose()
        }

        if ($file) {
            $file.Close()
            $file.Dispose()
        }
    }
    else {
        <#
            Will copy to the default Windows temporary folder
        #>
        Copy-Item -Path "$Path\HotfixInstallationInfo.xml" -Destination $pathHotfix -Force

        foreach ($nuget in $(Get-ChildItem -Path "$Path\AOSService\Packages\*.nupkg")) {
            Copy-Item -Path $nuget.FullName -Destination "$pathWorkDirectory\$($nuget.Name).zip" -Force
        }
    }

    if (Test-PSFFunctionInterrupt) { return }

    [System.Collections.Generic.List[System.Object]] $modules = @()

    foreach ($nuget in $(Get-ChildItem -Path "$pathWorkDirectory\*.nupkg.zip")) {
        <#
            nuget contains a nuspec file
            nuspec is a XML containing the details we are looking for
        #>
        $pathXml = $nuget.FullName + ".nuspec"

        $fileNuget = [System.IO.File]::Open($nuget.FullName, [System.IO.FileMode]::Open)
        $zipNuget = [System.IO.Compression.ZipArchive]::new($fileNuget)
        $zipNugetEntry = $zipNuget.Entries | Where-Object Name -like "*.nuspec" | Select-Object -First 1
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($zipNugetEntry, $pathXml, $true)

        [xml] $moduleSpec = Get-Content -Path $pathXml -Raw

        $modules.Add(
            [PSCustomObject]@{
                Name    = $moduleSpec.package.metadata.summary
                Version = $moduleSpec.package.metadata.version
            }
        )
    }

    # Clear out any inner zip archive objects from memory
    if ($zipNuget) {
        $zipArch.Dispose()
    }
    
    if ($fileNuget) {
        $file.Close()
        $file.Dispose()
    }

    [xml] $hotfix = Get-Content -Path "$pathWorkDirectory\HotfixInstallationInfo.xml" -Raw

    [PSCustomObject]@{
        Platform        = $hotfix.HotfixInstallationInfo.PlatformReleaseDisplayName
        PlatformVersion = $hotfix.HotfixInstallationInfo.PlatformVersion
        Modules         = $modules
    }
    
    Invoke-TimeSignal -End
}