function Backup-D365Runbook {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Path')]
        [string] $File,

        [Parameter(Mandatory = $false)]
        [string] $DestinationPath = $Script:DefaultTempPath
    )

    if (-not (Test-PathExists -Path $DestinationPath -Type Container -Create)) { return }

    if (-not (Test-PathExists -Path $File -Type Leaf)) { return }

    $destPath = Join-Path $DestinationPath "RunbooksBackup"
    $fileName = Split-Path -Path $File -Leaf

    Copy-Item -Path $File -Destination $(Join-Path $destPath $fileName)

}