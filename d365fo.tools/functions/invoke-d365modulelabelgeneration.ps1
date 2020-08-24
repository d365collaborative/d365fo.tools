
<#
    .SYNOPSIS
        Generate labels for a package / module / model
        
    .DESCRIPTION
        Generate labels for a package / module / model using the builtin "labelc.exe"
        
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
        PS C:\> Invoke-D365ModuleLabelGeneration -Module MyModel
        
        This will use the default paths and start the labelc.exe with the needed parameters to labels from the MyModel package.
        The default output from the generation process will be silenced.
        
        If an error should occur, both the standard output and error output will be written to the console / host.
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleLabelGeneration -Module MyModel -ShowOriginalProgress
        
        This will use the default paths and start the labelc.exe with the needed parameters to labels from the MyModel package.
        The output from the compile will be written to the console / host.
        
    .NOTES
        Tags: Compile, Model, Servicing, Label, Labels
        
        Author: Ievgen Miroshnikov (@IevgenMir)
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365ModuleLabelGeneration {
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

        $tool = "labelc.exe"
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

        $logFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$Module.labelc.log"
        $logErrorFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$Module.labelc.err"
  
        $params = @("-metadata=`"$MetaDataDir`"",
            "-modelmodule=`"$Module`"",
            "-output=`"$outputDirModule\Resources`"",
            "-outlog=`"$logFile`"",
            "-errlog=`"$logErrorFile`""
        )
    
        Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $logDirModule

        if ($OutputCommandOnly) { return }
        
        [PSCustomObject]@{
            OutLogFile   = $logFile
            ErrorLogFile = $logErrorFile
            PSTypeName   = 'D365FO.TOOLS.ModuleLabelGenerationOutput'
        }
    }

    end {
        Invoke-TimeSignal -End
    }
}