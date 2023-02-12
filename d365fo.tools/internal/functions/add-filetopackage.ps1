
<#
    .SYNOPSIS
        Add a file to an archive (zipped) file
        
    .DESCRIPTION
        Add the specified file to the specified archive (zipped) file in the specified path.
        
    .PARAMETER File
        Path to the file that you want to add to the archive
        
    .PARAMETER Archive
        Path to the archive (zipped) file where the file should be added
        
    .PARAMETER Path
        Path where the file should be added to the archive. Default is the root of the archive.
        
    .PARAMETER OutputPath
        Path where you want the modified archive to be stored. Default is the same path as the archive.
        
    .PARAMETER ClearPath
        If the path already exists in the archive, it will be cleared before adding the file. Default is false.
        
    .EXAMPLE
        PS C:\> Add-FileToPackage -File C:\Temp\MyFile.txt -Archive C:\Temp\MyPackage.zip -Path "AOSService\Scripts"
        
        This will take the "C:\Temp\MyFile.txt" file and add it to the C:\Temp\MyPackage.zip archive in the "AOSService\Scripts" folder.
        It will extract the "C:\Temp\MyPackage.zip" and add the "C:\Temp\MyFile.txt" in the "AOSService\Scripts" folder of the extracted archive.
        It will then compress (zip) the folder created by the extraction back into an archive file, overwriting the previous archive file.
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
        Author: Szabolcs Eötvös
        Author: Florian Hopfner (@FH-Inway)
        
#>
function Add-FileToPackage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]
        [string] $File,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 2 )]
        [string] $Archive,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [string] $Path = "",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [string] $OutputPath = $Archive,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [Switch] $ClearPath
    )

    begin {
    }

    process {
        if (-not (Test-PathExists -Path $File, $Archive -Type "Leaf")) { return }

        $null = New-Item -Path (Split-Path $OutputPath -Parent) -ItemType Directory -ErrorAction SilentlyContinue

        Unblock-File $File
        Unblock-File $Archive

        $ExtractionPath = [System.IO.Path]::GetTempPath()

        $packageTemp = Join-Path $ExtractionPath ((Get-Random -Maximum 99999).ToString())

        Write-PSFMessage -Level Verbose -Message "Extracting the archive zip file to $packageTemp." -Target $packageTemp
        Expand-Archive -Path $Archive -DestinationPath $packageTemp

        $mergePath = Join-Path $packageTemp $Path

        if (Test-Path -Path $mergePath) {
            if ($ClearPath) {
                Get-ChildItem -Path $mergePath | Remove-Item -Force -ErrorAction SilentlyContinue
            }
        }
        else {
            $null = New-Item -Path $mergePath -ItemType Directory -ErrorAction SilentlyContinue
        }

        Write-PSFMessage -Level Verbose -Message "Copying the file into place."
        Copy-Item -Path $File -Destination $mergePath

        Write-PSFMessage -Level Verbose -Message "Compressing the folder into a zip file and storing it at $OutputPath" -Target $OutputPath
        Compress-Archive -Path "$packageTemp\*" -DestinationPath $OutputPath -Force

        [PSCustomObject]@{
            File = $OutputPath
        }
    }

    end {
    }
}