
<#
    .SYNOPSIS
        Generate reports for a package / module / model
        
    .DESCRIPTION
        Generate reports for a package / module / model using the builtin "ReportsC.exe"
        
    .PARAMETER Module
        Name of the package that you want to work against
        
    .PARAMETER OutputDir
        The path to the folder to save generated artifacts
        
    .PARAMETER LogPath
        Path where you want to store the log outputs generated from the compiler
        
        Also used as the path where the log file(s) will be saved
        
        When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed
        
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
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleReportsCompile -Module MyModel
        
        This will use the default paths and start the ReportsC.exe with the needed parameters to compile the reports from the MyModel package.
        The default output from the reports compile will be silenced.
        
        If an error should occur, both the standard output and error output will be written to the console / host.
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleReportsCompile -Module MyModel -ShowOriginalProgress
        
        This will use the default paths and start the ReportsC.exe with the needed parameters to compile the reports from the MyModel package.
        The output from the compile will be written to the console / host.
        
    .NOTES
        Tags: Compile, Model, Servicing, Report, Reports
        
        Author: Ievgen Miroshnikov (@IevgenMir)
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365ModuleReportsCompile {
    [CmdletBinding()]
    [OutputType('[PsCustomObject]')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("ModuleName")]
        [string] $Module,

        [Alias('Output')]
        [string] $OutputDir = $Script:MetaDataDir,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\ModuleCompile"),

        [string] $MetaDataDir = $Script:MetaDataDir,

        [string] $ReferenceDir = $Script:MetaDataDir,

        [string] $BinDir = $Script:BinDirTools,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    begin {
        Invoke-TimeSignal -Start

        $tool = "ReportsC.exe"
        $executable = Join-Path -Path $BinDir -ChildPath $tool

        if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) { return }
        if (-not (Test-PathExists -Path $executable -Type Leaf)) { return }
        if (-not (Test-PathExists -Path $LogPath -Type Container -Create)) { return }
    }
    
    process {
        $logDirModule = Join-Path -Path $LogPath -ChildPath $Module
        $outputDirModule = Join-Path -Path $OutputDir -ChildPath $Module
        
        if (-not (Test-PathExists -Path $logDirModule -Type Container -Create)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        $logFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$Module.ReportsC.log"
        $logXmlFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$Module.ReportsC.xml"

        $params = @("-metadata=`"$MetaDataDir`"",
            "-modelmodule=`"$Module`"",
            "-LabelsPath=`"$MetaDataDir`"",
            "-output=`"$outputDirModule\Reports`"",
            "-log=`"$logFile`"",
            "-xmlLog=`"$logXmlFile`""
        )

        Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $logDirModule

        if ($OutputCommandOnly) { return }

        [PSCustomObject]@{
            LogFile    = $logFile
            XmlLogFile = $logXmlFile
            PSTypeName = 'D365FO.TOOLS.ModuleReportsCompileOutput'
        }
    }

    end {
        Invoke-TimeSignal -End
    }
}