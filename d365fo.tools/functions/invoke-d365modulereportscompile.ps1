function Invoke-D365ModuleReportsCompile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [string] $Module,

        [Parameter(Mandatory = $False, Position = 2 )]
        [Alias('Output')]
        [string] $OutputDir = (Join-Path $Script:MetaDataDir $Module),

        [Parameter(Mandatory = $False, Position = 3 )]
        [string] $LogDir = (Join-Path $Script:DefaultTempPath $Module),

        [Parameter(Mandatory = $False, Position = 4 )]
        [string] $MetaDataDir = $Script:MetaDataDir,

        [Parameter(Mandatory = $False, Position = 5)]
        [string] $ReferenceDir = $Script:MetaDataDir,

        [Parameter(Mandatory = $False, Position = 6 )]
        [string] $BinDir = $Script:BinDirTools,

        [Parameter(Mandatory = $False, Position = 7 )]
        [switch] $ShowOriginalProgress
    )

    Invoke-TimeSignal -Start

    $tool = "ReportsC.exe"
    $executable = Join-Path $BinDir $tool

    if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) {return}
    if (-not (Test-PathExists -Path $executable -Type Leaf)) {return}
    if (-not (Test-PathExists -Path $LogDir -Type Container -Create)) {return}

    $logFile = Join-Path $LogDir "Dynamics.AX.$Module.ReportsC.log"
    $logXmlFile = Join-Path $LogDir "Dynamics.AX.$Module.ReportsC.xml"

    $params = @("-metadata=`"$MetaDataDir`"",
        "-modelmodule=`"$Module`"",
        "-LabelsPath=`"$MetaDataDir`"",
        "-output=`"$OutputDir\Reports`"",
        "-log=`"$logFile`"",
        "-xmlLog=`"$logXmlFile`""
    )

    Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress

    Invoke-TimeSignal -End

    [PSCustomObject]@{
        LogFile = $logFile
        XmlLogFile = $logXmlFile
    }
}