function Clear-D365TableDataFromBacpac {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string[]] $TableName,

        [Parameter(Mandatory = $true)]
        [string] $OutputPath,

        [string] $ExtractionPath = $(Join-Path $Script:DefaultTempPath "BacpacExtractions"),

        [switch] $KeepFiles

    )
    
    begin {
        $originalExtension = ""

        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        
        if($Path -like "*.bacpac") {
            Write-PSFMessage -Level Verbose -Message "Renaming the bacpac file to zip, to be able to extract the file." -Target $Path

            Rename-Item -Path $Path -NewName "$($fileName).zip"

            $originalExtension = "bacpac½"
        }

        $workPath = Join-Path -Path $ExtractionPath -ChildPath $fileName
        $archivePath = Join-Path -Path $ExtractionPath -ChildPath "$($fileName).zip"

        if (-not (Test-PathExists -Path $ExtractionPath,$workPath -Type Container -Create)) { return }

        if (-not (Test-PathExists -Path $File -Type Leaf)) { return }

        Expand-Archive -Path $archivePath -DestinationPath $workPath -Force
    }
    
    process {
        if (Test-PSFFunctionInterrupt) { return }
        
        foreach ($table in $TableName) {
            
        }

    }
    
    end {
        if($originalExtension -eq "bacpac½"){
            Rename-Item -Path $archivePath -NewName "$($fileName).bacpac"

        }
    }
}