function Remove-D365Model {
    # [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [string] $Model,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [switch] $DeleteFolders
    )

    Invoke-TimeSignal -Start
    
    Invoke-ModelUtil -Command "Delete" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir -Model $Model

    if (Test-PSFFunctionInterrupt) { return }

    $modelPath = Join-Path $MetaDataDir $Model

    if ($DeleteFolders) {
        if (-not (Test-PathExists -Path $modelPath -Type Container)) { return }

        Remove-Item $modelPath -Force  -Recurse -ErrorAction SilentlyContinue
    }

    Invoke-TimeSignal -End
}