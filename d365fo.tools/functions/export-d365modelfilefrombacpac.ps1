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