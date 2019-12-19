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
        if ($originalExtension -eq "bacpac") {
            Rename-Item -Path $archivePath -NewName "$($fileName).bacpac"
        }

        if (Test-PSFFunctionInterrupt) { return }

        Compress-Archive -Path "$workPath\*" -DestinationPath $compressPath

        if ($newFilename -ne "") {
            Rename-Item -Path $compressPath -NewName $newFilename
        }

        if (-not $KeepFiles) {
            Remove-Item -Path $workPath -Recurse -Force
        }
    }
}