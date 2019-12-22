
<#
    .SYNOPSIS
        Extract the "model.xml" from the bacpac file
        
    .DESCRIPTION
        Extract the "model.xml" file from inside the bacpac file
        
        This can be used to update SQL Server options for how the SqlPackage.exe should import the bacpac file into your SQL Server / Azure SQL DB
        
    .PARAMETER Path
        Path to the bacpac file that you want to work against
        
        It can also be a zip file
        
    .PARAMETER OutputPath
        Path to where you want the updated bacpac file to be saved
        
    .PARAMETER ExtractionPath
        Path to where you want the cmdlet to extract the files from the bacpac file while it deletes data
        
        The default value is "c:\temp\d365fo.tools\BacpacExtractions"
        
        When working the cmdlet will create a sub-folder named like the bacpac file
        
    .PARAMETER Force
        Switch to instruct the cmdlet to overwrite the "model.xml" specified in the OutputPath
        
    .PARAMETER KeepFiles
        Switch to instruct the cmdlet to keep the extracted files and folders
        
        This will leave the files in place, after the extraction of the "model.xml" file
        
    .EXAMPLE
        PS C:\> Export-d365ModelFileFromBacpac -Path "C:\Temp\AxDB.bacpac" -OutputPath "C:\Temp\model.xml"
        
        This will extract the "model.xml" file from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "C:\Temp\model.xml" as the OutputPath to where it will store the extracted "model.xml" file.
        It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".
        
        It will delete the extracted files after extracting the "model.xml" file.
        
    .EXAMPLE
        PS C:\> Export-d365ModelFileFromBacpac -Path "C:\Temp\AxDB.bacpac" -OutputPath "C:\Temp\model.xml" -Force
        
        This will extract the "model.xml" file from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "C:\Temp\model.xml" as the OutputPath to where it will store the extracted "model.xml" file.
        It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".
        
        It will override the "C:\Temp\model.xml" if already present.
        
        It will delete the extracted files after extracting the "model.xml" file.
        
    .EXAMPLE
        PS C:\> Export-d365ModelFileFromBacpac -Path "C:\Temp\AxDB.bacpac" -OutputPath "C:\Temp\model.xml" -KeepFiles
        
        This will extract the "model.xml" file from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "C:\Temp\model.xml" as the OutputPath to where it will store the extracted "model.xml" file.
        It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".
        
        It will NOT delete the extracted files after extracting the "model.xml" file.
        
    .NOTES
        Tags: Bacpac, Servicing, Data, SqlPackage, Sql Server Options, Collation
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Export-D365ModelFileFromBacpac {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [Alias('BacpacFile')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $OutputPath,

        [string] $ExtractionPath = $(Join-Path $Script:DefaultTempPath "BacpacExtractions"),

        [switch] $Force,

        [switch] $KeepFiles
    )
    
    begin {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        $originalExtension = ""

        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        
        if ([string]::IsNullOrEmpty([system.IO.Path]::GetExtension($OutputPath))) {
            $OutputPath = Join-Path -Path $OutputPath -ChildPath "model.xml"
        }

        if ($Path -like "*.bacpac") {
            Write-PSFMessage -Level Verbose -Message "Renaming the bacpac file to zip, to be able to extract the file." -Target $Path

            Rename-Item -Path $Path -NewName "$($fileName).zip"

            $originalExtension = "bacpac"

            $archivePath = Join-Path -Path (Split-Path -Path $Path -Parent) -ChildPath "$($fileName).zip"
        }
        else {
            $archivePath = $Path
        }

        $workPath = Join-Path -Path $ExtractionPath -ChildPath $fileName

        if (-not (Test-PathExists -Path $ExtractionPath, $workPath -Type Container -Create)) { return }

        if (-not $Force) {
            if (-not (Test-PathExists -Path $OutputPath -Type Leaf -ShouldNotExist)) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$OutputPath</c> already exists. Consider changing the <c='em'>OutputPath</c> or set the <c='em'>Force</c> parameter to overwrite the file."
                Stop-PSFFunction -Message "Stopping because output path was already present."
                return
            }
        }

        if (Test-PSFFunctionInterrupt) { return }

        Expand-Archive -Path $archivePath -DestinationPath $workPath -Force

        Copy-Item -Path "$workPath\model.xml" -Destination $OutputPath

        [PSCustomObject]@{
            File = $OutputPath
            Filename = $(Split-Path -Path $OutputPath -Leaf)
        }
    }
    
    end {
        if ($originalExtension -eq "bacpac") {
            Rename-Item -Path $archivePath -NewName "$($fileName).bacpac"
        }
        
        if (-not $KeepFiles) {
            Remove-Item -Path $workPath -Recurse -Force
        }
    }
}