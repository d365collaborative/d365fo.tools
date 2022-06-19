
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
        
    .PARAMETER Force
        Switch to instruct the cmdlet to overwrite the "model.xml" specified in the OutputPath
        
    .EXAMPLE
        PS C:\> Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac"
        
        This will extract the "model.xml" file from inside the bacpac file.
        
        It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses the default value "c:\temp\d365fo.tools" as the OutputPath to where it will store the extracted "bacpac.model.xml" file.
        
    .EXAMPLE
        PS C:\> Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac" -OutputPath "c:\Temp\model.xml" -Force
        
        This will extract the "model.xml" file from inside the bacpac file.
        
        It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "c:\Temp\model.xml" as the OutputPath to where it will store the extracted "model.xml" file.
        
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
    [Alias("Get-D365ModelFileFromBacpac")]
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
        

        if ($OutputPath -eq $Script:DefaultTempPath) {
            $OutputPath = Join-Path -Path $OutputPath -ChildPath "bacpac.model.xml"
        }
        
        Test-PathExists -Path $(Split-Path -Path $OutputPath -Parent) -Type Container -Create > $null

        if (Test-PSFFunctionInterrupt) { return }

        if (-not $Force) {
            if (-not (Test-PathExists -Path $OutputPath -Type Leaf -ShouldNotExist)) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$OutputPath</c> already exists. Consider changing the <c='em'>OutputPath</c> or set the <c='em'>Force</c> parameter to overwrite the file."
                Stop-PSFFunction -Message "Stopping because output path was already present."
                return
            }
        }

        if (Test-PSFFunctionInterrupt) { return }
    }
    
    end {
        if (Test-PSFFunctionInterrupt) { return }
        
        $file = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open)

        $zipArch = [System.IO.Compression.ZipArchive]::new($file)
        
        $modelEntry = $zipArch.GetEntry("model.xml")

        if (-not $modelEntry) {
            $messageString = "Unable to find the <c='em'>model.xml</c> file inside the archive. It would indicate the <c='em'>$Path</c> isn't a valid bacpac or dacpac."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because model.xml wasn't found." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        }
        
        if (Test-PSFFunctionInterrupt) { return }

        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($modelEntry, $OutputPath, $true)

        if ($zipArch) {
            $zipArch.Dispose()
        }

        if ($file) {
            $file.Close()
            $file.Dispose()
        }
        
        [PSCustomObject]@{
            File     = $OutputPath
            Filename = $(Split-Path -Path $OutputPath -Leaf)
        }
    }
}