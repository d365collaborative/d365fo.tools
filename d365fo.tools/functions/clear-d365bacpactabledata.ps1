
<#
    .SYNOPSIS
        Clear out data for a table inside the bacpac/dacpac or zip file
        
    .DESCRIPTION
        Remove all data for a table inside a bacpac/dacpac or zip file, before restoring it into your SQL Server / Azure SQL DB
        
        It will open the file as a zip archive, locate the desired table and remove the data that otherwise would have been loaded
        
        The default behavior is that you get a copy of the file, where the desired data is removed
        
    .PARAMETER Path
        Path to the bacpac/dacpac or zip file that you want to work against
        
    .PARAMETER Table
        Name of the table that you want to delete the data for
        
        Supports an array of table names
        
        If a schema name isn't supplied as part of the table name, the cmdlet will prefix it with "dbo."
        
        Supports wildcard searching e.g. "Sales*" will delete all "dbo.Sales*" tables in the bacpac file
        
    .PARAMETER OutputPath
        Path to where you want the updated bacpac/dacpac or zip file to be saved
        
    .PARAMETER ClearFromSource
        Instruct the cmdlet to delete tables directly from the source file
        
        It will save disk space and time, because it doesn't have to create a copy of the bacpac file, before deleting tables from it
        
    .EXAMPLE
        PS C:\> Clear-D365BacpacTableData -Path "C:\Temp\AxDB.bacpac" -Table "BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
        
        This will remove the data from the BatchJobHistory table from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "BATCHJOBHISTORY" as the Table to delete data from.
        It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
        
    .EXAMPLE
        PS C:\> Clear-D365BacpacTableData -Path "C:\Temp\AxDB.bacpac" -Table "dbo.BATCHHISTORY","BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
        
        This will remove the data from the dbo.BatchHistory and BatchJobHistory table from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "dbo.BATCHHISTORY","BATCHJOBHISTORY" as the Table to delete data from.
        It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
        
    .EXAMPLE
        PS C:\> Clear-D365BacpacTableData -Path "C:\Temp\AxDB.bacpac" -Table "dbo.BATCHHISTORY","BATCHJOBHISTORY" -ClearFromSource
        
        This will remove the data from the dbo.BatchHistory and BatchJobHistory table from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "dbo.BATCHHISTORY","BATCHJOBHISTORY" as the Table to delete data from.
        
        Caution:
        It will remove from the source "C:\Temp\AxDB.bacpac" directly. So if the original file is important for further processing, please consider the risks carefully.
        
    .EXAMPLE
        PS C:\> Clear-D365BacpacTableData -Path "C:\Temp\AxDB.bacpac" -Table "CustomTableNameThatDoesNotExists","BATCHJOBHISTORY" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac" -ErrorAction SilentlyContinue
        
        This will remove the data from the BatchJobHistory table from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "CustomTableNameThatDoesNotExists","BATCHJOBHISTORY" as the Table to delete data from.
        It respects the respects the ErrorAction "SilentlyContinue", and will continue removing tables from the bacpac file, even when some tables are missing.
        It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
        
    .NOTES
        Tags: Bacpac, Servicing, Data, Deletion, SqlPackage
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Clear-D365BacpacTableData {
    [Alias("Clear-D365TableDataFromBacpac")]
    [CmdletBinding(DefaultParameterSetName = "Copy")]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [Alias('BacpacFile')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [Alias("TableName")]
        [string[]] $Table,

        [Parameter(Mandatory = $true, ParameterSetName = "Copy")]
        [string] $OutputPath,

        [Parameter(Mandatory = $true, ParameterSetName = "Keep")]
        [switch] $ClearFromSource
    )
    
    begin {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        $compressPath = ""

        if ($ClearFromSource) {
            $compressPath = $Path
        }
        else {
            $compressPath = $OutputPath

            if (-not (Test-PathExists -Path $compressPath -Type Leaf -ShouldNotExist)) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$compressPath</c> already exists. Consider changing the <c='em'>OutputPath</c> or <c='em'>delete</c> the <c='em'>$compressPath</c> file."
                return
            }

            if (Test-PSFFunctionInterrupt) { return }

            Write-PSFMessage -Level Verbose -Message "Copying the file from '$Path' to '$compressPath'"
            Copy-Item -Path $Path -Destination $compressPath
            Write-PSFMessage -Level Verbose -Message "Copying was completed."
        }
        
        Write-PSFMessage -Level Verbose -Message "Opening the file '$compressPath'."
        $file = [System.IO.File]::Open($compressPath, [System.IO.FileMode]::Open)
        $zipArch = [System.IO.Compression.ZipArchive]::new($file, [System.IO.Compression.ZipArchiveMode]::Update)
        Write-PSFMessage -Level Verbose -Message "File '$compressPath' was read succesfully."

        if (-not $zipArch) {
            $messageString = "Unable to open the file <c='em'>$compressPath</c>."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because the file couldn't be opened." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
            return
        }
    }
    
    process {
        if (Test-PSFFunctionInterrupt) { return }
        
        foreach ($item in $Table) {
            $fullTableName = ""

            if (-not ($item -like "*.*")) {
                $fullTableName = "dbo.$item"
            }
            else {
                $fullTableName = $item
            }

            Write-PSFMessage -Level Verbose -Message "Looking for $fullTableName."
            $entries = @($zipArch.Entries | Where-Object Fullname -like "Data/$fullTableName/*")

            if ($entries.Count -lt 1) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$item</c> wasn't found. Please ensure that the <c='em'>schema</c> or <c='em'>name</c> is correct."
                
                $parms = @{Message = "Stopping because table was not present." }
                if ($ErrorActionPreference -eq "SilentlyContinue") {
                    $parms.WarningAction = $ErrorActionPreference
                    $parms.ErrorAction = $null
                }

                Stop-PSFFunction @parms
            }
            else {
                for ($i = 0; $i -lt $entries.Count; $i++) {
                    Write-PSFMessage -Level Verbose -Message "Removing $($entries[$i]) from the file."

                    $entries[$i].delete()
                }
            }
        }
    }
    
    end {
        Write-PSFMessage -Level Verbose -Message "Search completed."

        $res = @{ }

        if ($zipArch) {
            Write-PSFMessage -Level Verbose -Message "Closing and saving the file."
            $zipArch.Dispose()
        }

        if ($file) {
            $file.Close()
            $file.Dispose()
        }
        
        if (Test-PSFFunctionInterrupt) { return }

        $res.File = $compressPath
        $res.Filename = $(Split-Path -Path $compressPath -Leaf)

        [PSCustomObject]$res
    }
}