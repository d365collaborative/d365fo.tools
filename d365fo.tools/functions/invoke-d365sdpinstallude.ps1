
<#
    .SYNOPSIS
        Install a Software Deployable Package (SDP) in a unified development environment
        
    .DESCRIPTION
        A cmdlet that wraps some of the cumbersome work into a streamlined process.
        It first checks if the package is a zip file and extracts it if necessary.
        Then it checks if the package contains the necessary files and modules.
        Finally, it extracts the module zip files into the metadata directory.
        
    .PARAMETER Path
        Path to the package that you want to install into the environment
        
        The cmdlet supports a path to a zip-file or directory with the unpacked contents.
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
    .PARAMETER LogPath
        The path where the log file(s) will be saved
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the "extracted" folder if it exists
        
        Used when the input is a zip file, that will auto extract to a folder named like the zip file.
        
    .EXAMPLE
        PS C:\> Invoke-D365SDPInstallUDE -Path "c:\temp\package.zip" -MetaDataDir "c:\MyRepository\Metadata"
        
        This will install the modules contained in the c:\temp\package.zip file into the c:\MyRepository\Metadata directory.
        
    .NOTES
        Author: Florian Hopfner (@FH-Inway)
        
#>
function Invoke-D365SDPInstallUDE {
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [Alias('Hotfix')]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string] $MetaDataDir,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\SdpInstall"),

        [switch] $Force
    )
  
    if ((Get-Process -Name "devenv" -ErrorAction SilentlyContinue).Count -gt 0) {
        Write-PSFMessage -Level Host -Message "It seems that you have a <c='em'>Visual Studio</c> running. Please ensure <c='em'>exit</c> Visual Studio and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because of running Visual Studio."
        return
    }

    Invoke-TimeSignal -Start

  
    #Test if input is a zipFile that needs to be extracted first
    if ($Path.EndsWith(".zip")) {
        Unblock-File -Path $Path
        
        $extractedPath = $path.Remove($path.Length - 4)

        if (-not $Force) {
            if (-not (Test-PathExists -Path $extractedPath -Type Container -ShouldNotExist)) {
                Write-PSFMessage -Level Host -Message "The directory at the <c='em'>$extractedPath</c> location already exists. If you want to override it - set the <c='em'>Force</c> parameter to clear the folder and extract the content into it."
                Stop-PSFFunction -Message "Stopping because output path was already present."
                return
            }
        }

        Get-ChildItem -Path $extractedPath -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -Confirm:$false
        
        # To allow the file system to flush the files
        # Allows the human to see the folder being wiped
        Start-Sleep -Seconds 2

        Expand-Archive -Path $Path -DestinationPath $extractedPath -Force
        $Path = $extractedPath
    }

    # Input is a relative path which needs to be converted to an absolute path.
    # see https://powershellmagazine.com/2013/01/16/pstip-check-if-the-path-is-relative-or-absolute/
    if (-not ([System.IO.Path]::IsPathRooted($Path) -or (Split-Path -Path $Path -IsAbsolute))) {
        $currentPath = Get-Location
        # https://stackoverflow.com/a/13847304/2720554
        $absolutePath = Join-Path -Path $currentPath -ChildPath $Path
        $absolutePath = [System.IO.Path]::GetFullPath($absolutePath)
        Write-PSFMessage -Level Verbose "Updating path to '$absolutePath' as relative paths are not supported"
        $Path = $absolutePath
    }
    
    Get-ChildItem -Path $Path -Recurse | Unblock-File
    $packageDetails = Get-D365SDPDetails -Path $Path

    $packagesFolder = "$Path\AOSService\Packages"
    $filesFolder = Get-ChildItem -Path $packagesFolder -Directory -Filter "files"
    if ($filesFolder.Count -eq 0) {
        Write-PSFMessage -Level Host -Message "No /AOSService/Packages/files folder found in the package. Please ensure that the package is extracted correctly."
        Stop-PSFFunction -Message "Stopping because of missing files folder."
        return
    }

    $zipFiles = Get-ChildItem -Path $filesFolder.FullName -File -Filter "*.zip"
    if ($zipFiles.Count -eq 0) {
        Write-PSFMessage -Level Host -Message "No module zip files found in the package. Please ensure that the package is extracted correctly."
        Stop-PSFFunction -Message "Stopping because of missing zip files."
        return
    }

    $numberOfInstalledModules = 0
    $packageDetails.Modules | ForEach-Object {
        $moduleZip = $zipFiles | Where-Object Name -eq "dynamicsax-$($_.Name).$($_.Version).zip"
        if (-not $moduleZip) {
            Write-PSFMessage -Level Host -Message "No module zip file found for module $($_.Name). Please ensure that the package is extracted correctly."
            Stop-PSFFunction -Message "Stopping because of missing module zip file."
            return
        }

        # Delete existing module folder if it exists
        $moduleFolderPath = Join-Path -Path $MetaDataDir -ChildPath $($_.Name)
        if (Test-Path -Path $moduleFolderPath) {
            Remove-Item -Path $moduleFolderPath -Recurse -Force
            Write-PSFMessage -Level Verbose -Message "Deleted existing module folder $moduleFolderPath"
        }

        # Unzip to $MetaDataDir
        $moduleZipPath = Join-Path -Path $MetaDataDir -ChildPath $($_.Name)
        Expand-Archive -Path $moduleZip.FullName -DestinationPath $moduleZipPath
        Write-PSFMessage -Level Verbose -Message "Unzipped module $($_.Name) to $moduleZipPath"
        $numberOfInstalledModules++
    }

    Write-PSFMessage -Level Host -Message "Installed $numberOfInstalledModules module(s) into $MetaDataDir"

    Invoke-TimeSignal -End
  
}