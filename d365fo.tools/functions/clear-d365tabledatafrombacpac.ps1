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
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        $workPath = Join-Path -Path $ExtractionPath -ChildPath $fileName

        if (-not (Test-PathExists -Path $ExtractionPath,$workPath -Type Container -Create)) { return }

        if (-not (Test-PathExists -Path $File -Type Leaf)) { return }

        Expand-Archive -Path $Path -DestinationPath $workPath -Force
    }
    
    process {
        if (Test-PSFFunctionInterrupt) { return }
        
        foreach ($table in $TableName) {
            
        }

    }
    
    end {
        
    }
}