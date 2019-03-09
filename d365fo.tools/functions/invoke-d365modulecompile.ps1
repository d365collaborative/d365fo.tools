
<#
    .SYNOPSIS
        Compile a package / module / model
        
    .DESCRIPTION
        Compile a package / module / model using the builtin "xppc.exe" executable to compile source code
        
    .PARAMETER Module
        The package to compile
        
    .PARAMETER OutputDir
        The path to the folder to save generated artifacts
        
    .PARAMETER LogDir
        The path to the folder to save logs
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER ReferenceDir
        The full path of a folder containing all assemblies referenced from X++ code
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console

        Default is $false which will silence the standard output

    .EXAMPLE
        PS C:\> Invoke-D365ModuleCompile -Module MyModel
        
        This will use the default paths and start the xppc.exe with the needed parameters to compile MyModel package.
        The default output from the compile will be silenced.
        
        If an error should occur, both the standard output and error output will be written to the console / host.
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleCompile -Module MyModel -ShowOriginalProgress
        
        This will use the default paths and start the xppc.exe with the needed parameters to compile MyModel package.
        The output from the compile will be written to the console / host.
        
    .NOTES
        Tags: Compile, Model, Servicing, X++
        
        Author: Ievgen Miroshnikov (@IevgenMir)
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365ModuleCompile {
    [CmdletBinding()]
    [OutputType('[PsCustomObject]')]
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

    $tool = "xppc.exe"
    $executable = Join-Path $BinDir $tool

    if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) {return}
    if (-not (Test-PathExists -Path $executable -Type Leaf)) {return}
    if (-not (Test-PathExists -Path $LogDir -Type Container -Create)) {return}

    if (Test-PSFFunctionInterrupt) { return }

    $logFile = Join-Path $LogDir "Dynamics.AX.$Module.xppc.log"
    $logXmlFile = Join-Path $LogDir "Dynamics.AX.$Module.xppc.xml"

    $params = @("-metadata=`"$MetaDataDir`"",
        "-modelmodule=`"$Module`"",
        "-output=`"$OutputDir\bin`"",
        "-referencefolder=`"$ReferenceDir`"",
        "-log=`"$logFile`"",
        "-xmlLog=`"$logXmlFile`"",
        "-verbose"
    )

    Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress

    Invoke-TimeSignal -End

    [PSCustomObject]@{
        LogFile = $logFile
        XmlLogFile = $logXmlFile
    }
}