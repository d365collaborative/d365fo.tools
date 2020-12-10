
<#
    .SYNOPSIS
        Export data from a table inside the bacpac file
        
    .DESCRIPTION
        Export all data for a table inside a bacpac file into a directory
        
        It will convert the bacpac file to a zip archive, locate the desired table and extract all the bulk files for that specific table
        
        It will revert the zip back to bacpac file for you
        
        Caution:
        Working against big bacpac files (10+ GB) will put pressure on your memory consumption on the machine where you run this command
        
    .PARAMETER Path
        Path to the bacpac file that you want to work against
        
    .PARAMETER TableName
        Name of the table that you want to export the data from
        
        Supports an array of table names
        
        If a schema name isn't supplied as part of the table name, the cmdlet will prefix it with "dbo."
        
    .PARAMETER OutputPath
        Path to where you want the bulk data exported to be saved
        
    .EXAMPLE
        PS C:\> Export-D365TableDataFromBacpac -Path "C:\Temp\AxDB.bacpac" -TableName "BATCHJOBHISTORY" -OutputPath "C:\Temp\Extract"
        
        This will extract the bulk data from the BatchJobHistory table from inside the bacpac file and output it to "C:\Temp\Extract".
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "BATCHJOBHISTORY" as the TableName to extract data from, and will default to the "dbo" schema.
        It uses "C:\Temp\Extract\dbo.BatchJobHistory" as the OutputPath to where it will store the extracted bulk data file(s).
        
    .NOTES
        Tags: Bacpac, Servicing, Data, SqlPackage, Bulk, Export, Extract
        
        Author: Mötz Jensen (@Splaxi)
        
        Caution:
        Working against big bacpac files (10+ GB) will put pressure on your memory consumption on the machine where you run this command
#>

function Export-D365TableDataFromBacpac {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [Alias('BacpacFile')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string[]] $TableName,

        [string] $OutputPath = $(Join-Path $Script:DefaultTempPath "BacpacTables")
    )
    
    begin {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        $compressPath = $Path.Replace(".bacpac", ".zip")
        $newFilename = Split-Path -Path $compressPath -Leaf

        if (-not (Test-PathExists -Path $compressPath -Type Leaf -ShouldNotExist)) {
            Write-PSFMessage -Level Host -Message "The <c='em'>$compressPath</c> already exists. We need to convert the bacpac file to a zip file, in order to open it and extract data. Please <c='em'>delete</c> the <c='em'>$compressPath</c> file."
            return
        }

        Rename-Item -Path $Path -NewName $newFilename

        if (Test-PSFFunctionInterrupt) { return }

        $zipFileMetadata = [System.IO.Compression.ZipFile]::Open($compressPath, [System.IO.Compression.ZipArchiveMode]::Update)
    }
    
    process {
        if (Test-PSFFunctionInterrupt) { return }
        
        foreach ($table in $TableName) {
            $fullTableName = ""

            if (-not ($table -like "*.*")) {
                $fullTableName = "dbo.$table"
            }
            else {
                $fullTableName = $table
            }

            $entries = $zipFileMetadata.Entries | Where-Object Fullname -like "Data/*$fullTableName*"

            if ($entries.Count -lt 1) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$table</c> wasn't found. Please ensure that the <c='em'>schema</c> or <c='em'>name</c> is correct."
                $parms = @{Message = "Stopping because table was not present." }
                if ($ErrorActionPreference -eq "SilentlyContinue") {
                    $parms.WarningAction = $ErrorActionPreference
                    $parms.ErrorAction = $null
                }

                Stop-PSFFunction @parms
            }

            for ($i = 0; $i -lt $entries.Count; $i++) {
                $extractPath = Join-Path -Path "$OutputPath\$table" -ChildPath $entries[$i].Name
                $null = Test-PathExists -Path "$OutputPath\$table" -Type Container -Create
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entries[$i], $extractPath, $true)
            }
        }
    }
    
    end {
        if ($zipFileMetadata) {
            $zipFileMetadata.Dispose()
        }

        Rename-Item -Path $compressPath -NewName $(Split-Path -Path $Path -Leaf)
    }
}