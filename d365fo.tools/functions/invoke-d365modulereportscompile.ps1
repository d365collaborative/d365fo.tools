<#
    .SYNOPSIS
        Compile a package
        
    .DESCRIPTION
        Compile a package using the builtin "xppc.exe" executable to compile source code, "labelc.exe" to compile label files and "reportsc.exe" to compile reports
        
    .PARAMETER Module
        The package to compile
        
    .PARAMETER OutputDir
        The path to the folder to save assemblies

    .PARAMETER LogDir
        The path to the folder to save logs
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
    .PARAMETER ReferenceDir
        The full path of a folder containing all assemblies referenced from X++ code
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .EXAMPLE
        PS C:\> Invoke-D365CompileModule -Module MyModel
        
        This will use the default paths and start the xppc.exe with the needed parameters to copmile MyModel package.
        
    .NOTES
        Tags: Compile, Model, Servicing
        
        Author: Ievgen Miroshnikov (@IevgenMir)
        
#>

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
        [string] $BinDir = $Script:BinDirTools
    )

    $reportsc = Join-Path $BinDir "ReportsC.exe"

    if (-not (Test-PathExists -Path $MetaDataDir,$BinDir -Type Container)) {return}
    if (-not (Test-PathExists -Path $Path,$xppc -Type Leaf)) {return}
    if (-not (Test-PathExists -Path $Path,$labelc -Type Leaf)) {return}
    if (-not (Test-PathExists -Path $Path,$reportsc -Type Leaf)) {return}
    if (-not (Test-PathExists -Path $LogDir -Type Container -Create)) {return}

    #REPORTC

    $logFile = Join-Path $LogDir "Dynamics.AX.$Module.ReportsC.log"
    $logXmlFile = Join-Path $LogDir "Dynamics.AX.$Module.ReportsC.xml"

    $params = @("-metadata=`"$MetaDataDir`"",
        "-modelmodule=`"$Module`"",
        "-LabelsPath=`"$MetaDataDir`"",
        "-output=`"$OutputDir\Reports`"",
        "-log=`"$logFile`"",
        "-xmlLog=`"$logXmlFile`""
        )

    Write-PSFMessage -Level Debug -Message "reportsc.exe"

    Start-Process -FilePath $reportsc -ArgumentList ($params -join " ") -NoNewWindow -Wait

    foreach ($line in Get-Content "$logFile") {
        Write-PSFMessage -Level Output -Message "$line"
    }
}
