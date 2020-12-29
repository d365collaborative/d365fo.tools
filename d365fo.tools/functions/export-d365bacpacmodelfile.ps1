
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
        
        Default value is: "c:\temp\d365fo.tools"
        
    .PARAMETER ExtractionPath
        Path to where you want the cmdlet to extract the files from the bacpac file while it deletes data
        
        The default value is "c:\temp\d365fo.tools\BacpacExtractions"
        
        When working the cmdlet will create a sub-folder named like the bacpac file
        
    .PARAMETER Force
        Switch to instruct the cmdlet to overwrite the "model.xml" specified in the OutputPath
        
    .EXAMPLE
        PS C:\> Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac"
        
        This will extract the "model.xml" file from inside the bacpac file.
        
        It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses the default value "c:\temp\d365fo.tools" as the OutputPath to where it will store the extracted "bacpac.model.xml" file.
        It uses the default ExtractionPath folder "c:\Temp\d365fo.tools\BacpacExtractions".
        
    .EXAMPLE
        PS C:\> Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac" -OutputPath "c:\Temp\model.xml" -Force
        
        This will extract the "model.xml" file from inside the bacpac file.
        
        It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "c:\Temp\model.xml" as the OutputPath to where it will store the extracted "model.xml" file.
        It uses the default ExtractionPath folder "c:\Temp\d365fo.tools\BacpacExtractions".
        
        It will override the "c:\Temp\model.xml" if already present.
        
    .EXAMPLE
        PS C:\> Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac" | Get-D365BacpacSqlOptions
        
        This will display all the SQL Server options configured in the bacpac file.
        First it will export the bacpac.model.xml from the "c:\Temp\AxDB.bacpac" file, using the Export-D365BacpacModelFile function.
        The output from Export-D365BacpacModelFile will be piped into the Get-D365BacpacSqlOptions function.
        
    .NOTES
        Tags: Bacpac, Servicing, Data, SqlPackage, Sql Server Options, Collation
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Export-D365BacpacModelFile {
    [Alias("Export-D365ModelFileFromBacpac")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [Alias('BacpacFile')]
        [string] $Path,

        [string] $OutputPath = $Script:DefaultTempPath,

        [switch] $Force
    )
    
    begin {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        $originalExtension = ""

        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        
        if ([System.IO.File]::GetAttributes($OutputPath).HasFlag([System.IO.FileAttributes]::Directory)) {
            $OutputPath = Join-Path -Path $OutputPath -ChildPath "bacpac.model.xml"
        }

        if ($Path -like "*.bacpac") {
            Write-PSFMessage -Level Verbose -Message "Renaming the bacpac file to zip, to be able to extract the file. $($fileName).zip" -Target $Path

            Rename-Item -Path $Path -NewName "$($fileName).zip"

            $originalExtension = "bacpac"

            $archivePath = Join-Path -Path (Split-Path -Path $Path -Parent) -ChildPath "$($fileName).zip"
        }
        else {
            $archivePath = $Path
        }

        if (-not $Force) {
            if (-not (Test-PathExists -Path $OutputPath -Type Leaf -ShouldNotExist)) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$OutputPath</c> already exists. Consider changing the <c='em'>OutputPath</c> or set the <c='em'>Force</c> parameter to overwrite the file."
                Stop-PSFFunction -Message "Stopping because output path was already present."
                return
            }
        }

        if (Test-PSFFunctionInterrupt) { return }

        $zipFileMetadata = [System.IO.Compression.ZipFile]::OpenRead($archivePath)
        
        $modelFile = $zipFileMetadata.Entries | Where-Object { $_.Name -like "model.xml" } | Select-Object -First 1

        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($modelFile, $OutputPath, $true)
        $zipFileMetadata.Dispose()

        [PSCustomObject]@{
            File     = $OutputPath
            Filename = $(Split-Path -Path $OutputPath -Leaf)
        }
    }
    
    end {
        if ($originalExtension -eq "bacpac") {
            Rename-Item -Path $archivePath -NewName "$($fileName).bacpac"
        }
    }
}