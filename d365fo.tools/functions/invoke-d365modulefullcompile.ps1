
<#
    .SYNOPSIS
        Compile a package
        
    .DESCRIPTION
        Compile a package using the builtin "xppc.exe" executable to compile source code, "labelc.exe" to compile label files and "reportsc.exe" to compile reports
        
    .PARAMETER Module
        The package to compile
        
    .PARAMETER OutputDir
        The path to the folder to save assemblies
        
    .PARAMETER LogPath
        Path where you want to store the log outputs generated from the compiler
        
        Also used as the path where the log file(s) will be saved
        
        When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
    .PARAMETER ReferenceDir
        The full path of a folder containing all assemblies referenced from X++ code
        
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
        PS C:\> Invoke-D365ModuleFullCompile -Module MyModel
        
        This will use the default paths and start the xppc.exe with the needed parameters to compile MyModel package.
        The default output from all the different steps will be silenced.
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleFullCompile -Module MyModel -ShowOriginalProgress
        
        This will use the default paths and start the xppc.exe with the needed parameters to copmile MyModel package.
        The default output from the different steps will be written to the console / host.
        
    .NOTES
        Tags: Compile, Model, Servicing
        
        Author: Ievgen Miroshnikov (@IevgenMir)
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365ModuleFullCompile {
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

        if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) { return }
        if (-not (Test-PathExists -Path $LogPath -Type Container -Create)) { return }
    }

    process {
        $resModuleCompile = Invoke-D365ModuleCompile @PSBoundParameters

        $resLabelGeneration = Invoke-D365ModuleLabelGeneration @PSBoundParameters

        $resReportsCompile = Invoke-D365ModuleReportsCompile @PSBoundParameters
    
        $resModuleCompile

        $resLabelGeneration

        $resReportsCompile
    }

    end {
        Invoke-TimeSignal -End
    }
}