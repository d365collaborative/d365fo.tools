
<#
    .SYNOPSIS
        Clear out data for a table inside the bacpac file
        
    .DESCRIPTION
        Remove all data for a table inside a bacpac file, before restoring it into your SQL Server / Azure SQL DB
        
        It will extract the bacpac file as a zip archive, locate the desired table and remove the data that otherwise would have been loaded
        
        It will re-zip / compress a new bacpac file for you
        
    .PARAMETER Path
        Path to the bacpac file that you want to work against
        
        It can also be a zip file
        
    .PARAMETER TableName
        Name of the table that you want to delete the data for
        
        Supports an array of table names
        
        If a schema name isn't supplied as part of the table name, the cmdlet will prefix it with "dbo."
        
    .PARAMETER OutputPath
        Path to where you want the updated bacpac file to be saved
        
    .PARAMETER ExtractionPath
        Path to where you want the cmdlet to extract the files from the bacpac file while it deletes data
        
        The default value is "c:\temp\d365fo.tools\BacpacExtractions"
        
        When working the cmdlet will create a sub-folder named like the bacpac file
        
    .PARAMETER KeepFiles
        Switch to instruct the cmdlet to keep the extracted files and folders
        
        This will leave the files in place, after the deletion of the desired data
        
    .EXAMPLE
        PS C:\> Clear-D365TableDataFromBacpac -Path "C:\Temp\AxDB.bacpac" -TableName "BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
        
        This will remove the data from the BatchJobHistory table from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "BATCHJOBHISTORY" as the TableName to delete data from.
        It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
        It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".
        
        It will delete the extracted files after storing the updated bacpac file.
        
    .EXAMPLE
        PS C:\> Clear-D365TableDataFromBacpac -Path "C:\Temp\AxDB.bacpac" -TableName "BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac" -KeepFiles
        
        This will remove the data from the BatchJobHistory table from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "BATCHJOBHISTORY" as the TableName to delete data from.
        It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
        It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".
        
        It will NOT delete the extracted files after storing the updated bacpac file.
        
    .EXAMPLE
        PS C:\> Clear-D365TableDataFromBacpac -Path "C:\Temp\AxDB.bacpac" -TableName "dbo.BATCHHISTORY","BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
        
        This will remove the data from the BatchJobHistory table from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "dbo.BATCHHISTORY","BATCHJOBHISTORY" as the TableName to delete data from.
        It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
        It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".
        
        It will delete the extracted files after storing the updated bacpac file.
        
    .NOTES
        Tags: Bacpac, Servicing, Data, Deletion, SqlPackage
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Clear-D365TableDataFromBacpac {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [Alias('BacpacFile')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string[]] $TableName,

        [Parameter(Mandatory = $true)]
        [string] $OutputPath,

        [string] $ExtractionPath = $(Join-Path $Script:DefaultTempPath "BacpacExtractions"),

        [switch] $KeepFiles

    )
    
    begin {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        $compressPath = ""
        $newFilename = ""
        $originalExtension = ""

        if ($OutputPath -like "*.bacpac") {
            $compressPath = $OutputPath.Replace(".bacpac", ".zip")
            $newFilename = Split-Path -Path $OutputPath -Leaf
        }
        else {
            $compressPath = $OutputPath
        }

        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        
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


        if (-not (Test-PathExists -Path $compressPath -Type Leaf -ShouldNotExist)) {
            Write-PSFMessage -Level Host -Message "The <c='em'>$compressPath</c> already exists. Consider changing the <c='em'>OutputPath</c> or <c='em'>delete</c> the <c='em'>$compressPath</c> file."
            return
        }

        if (-not (Test-PathExists -Path $OutputPath -Type Leaf -ShouldNotExist)) {
            Write-PSFMessage -Level Host -Message "The <c='em'>$OutputPath</c> already exists. Consider changing the <c='em'>OutputPath</c> or <c='em'>delete</c> the <c='em'>$OutputPath</c> file."
            return
        }

        if (Test-PSFFunctionInterrupt) { return }

        Expand-Archive -Path $archivePath -DestinationPath $workPath -Force
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

            $deletePath = Join-Path "$workPath\Data" -ChildPath $fullTableName

            if (-not (Test-PathExists -Path $deletePath -Type Container -WarningAction SilentlyContinue -ErrorAction SilentlyContinue)) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$table</c> wasn't found. Please ensure that the <c='em'>schema</c> or <c='em'>name</c> is correct."
                Stop-PSFFunction -Message "Stopping because table was not present."
                return
            }
            else {
                Remove-Item -Path $deletePath -Recurse -Force
            }
        }

    }
    
    end {
        $res = @{}

        if ($originalExtension -eq "bacpac") {
            Rename-Item -Path $archivePath -NewName "$($fileName).bacpac"
        }

        if (Test-PSFFunctionInterrupt) { return }

        Compress-Archive -Path "$workPath\*" -DestinationPath $compressPath

        if ($newFilename -ne "") {
            Rename-Item -Path $compressPath -NewName $newFilename
            $res.File = Join-path -Parent $(Split-Path -Path $compressPath -Parent) -ChildPath $newFilename
            $res.Filename = $newFilename
        }else {
            $res.File = $compressPath
            $res.Filename = $(Split-Path -Path $compressPath -Leaf)
        }

        if (-not $KeepFiles) {
            Remove-Item -Path $workPath -Recurse -Force
        }

        [PSCustomObject]$res
    }
}