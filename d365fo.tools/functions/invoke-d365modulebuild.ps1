
<#
    .SYNOPSIS
        Build a package / module (X++ compile + labels, reports optional)
        
    .DESCRIPTION
        Build a package / module using the builtin "xppc.exe" executable to compile source code and "labelc.exe" to compile label files
        
        Specify -IncludeReports to also compile reports using "ReportsC.exe"
        
        Returns a result object per module and writes the compiler errors to the console when a module fails
        
        Exits with a terminating error when any module fails
        
    .PARAMETER Module
        The package to build
        
    .PARAMETER OutputDir
        The path to the folder to save assemblies
        
    .PARAMETER LogPath
        Path where you want to store the log outputs generated from the compiler
        
        Also used as the path where the log file(s) will be saved
        
        When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
    .PARAMETER ReferenceDir
        The full path of one or more folders containing all assemblies referenced from X++ code
        
        Accepts multiple folders, one "-referencefolder" argument is passed to the compiler per folder
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .PARAMETER IncludeReports
        Instruct the cmdlet to also compile the reports of the module using "ReportsC.exe"
        
        Default is $false which will skip the reports compile
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .PARAMETER Verbosity
        Controls how much output is written to the console
        
        None only outputs when there are errors. Minimal always returns the result object, with the compiler errors on failure. Detailed streams the live compiler output. Default is None
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleBuild -Module Essence-Temp
        
        This will use the default paths and start the xppc.exe with the needed parameters to compile the Essence-Temp package.
        When the X++ compile succeeds it will start the labelc.exe to compile the labels.
        The build result is returned as an object.
        If the build fails, the compiler errors are written to the console.
        The default output from all the different steps will be silenced.
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleBuild -Module Essence-Temp -IncludeReports -ShowOriginalProgress
        
        This will compile X++, labels and reports for the Essence-Temp package.
        The output from the different steps will be written to the console / host.
        
    .NOTES
        Tags: Compile, Model, Servicing, Build, X++
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365ModuleBuild {
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

        [string[]] $ReferenceDir = @($Script:MetaDataDir),

        [string] $BinDir = $Script:BinDirTools,

        [switch] $IncludeReports,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly,

        [ValidateSet("None", "Minimal", "Detailed")]
        [string] $Verbosity = "None"
    )

    begin {
        Invoke-TimeSignal -Start

        $moduleInputs = [System.Collections.Generic.List[string]]::new()
        $failedModules = [System.Collections.Generic.List[string]]::new()

        if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) { return }
        if (-not (Test-PathExists -Path @($ReferenceDir) -Type Container)) { return }
        if (-not (Test-PathExists -Path $LogPath -Type Container -Create)) { return }

        $xppcExecutable = Join-Path -Path $BinDir -ChildPath "xppc.exe"
        $labelExecutable = Join-Path -Path $BinDir -ChildPath "labelc.exe"
        $reportsExecutable = Join-Path -Path $BinDir -ChildPath "ReportsC.exe"

        if (-not (Test-PathExists -Path $xppcExecutable, $labelExecutable -Type Leaf)) { return }

        if ($IncludeReports) {
            if (-not (Test-PathExists -Path $reportsExecutable -Type Leaf)) { return }
        }

        if ([string]::IsNullOrWhiteSpace($OutputDir)) {
            Stop-PSFFunction -Message "Stopping because OutputDir was either null or empty string. It defaults to the registered MetaDataDir, which is not available on this machine. Please supply -OutputDir explicitly."
            return
        }

        $showLive = $ShowOriginalProgress -or ($Verbosity -eq 'Detailed')
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        if ([string]::IsNullOrWhiteSpace($Module)) {
            Write-PSFMessage -Level Warning -Message "Module parameter is empty. Skipping."
            return
        }

        $moduleInputs.Add($Module.Trim())
    }

    end {
        if (Test-PSFFunctionInterrupt) { return }

        foreach ($moduleName in $moduleInputs) {
            $logDirModule = Join-Path -Path $LogPath -ChildPath $moduleName
            $outputDirModule = Join-Path -Path $OutputDir -ChildPath $moduleName

            if (-not (Test-PathExists -Path $logDirModule -Type Container -Create)) { continue }

            $logFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$moduleName.xppc.log"
            $logXmlFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$moduleName.xppc.xml"
            $labelLogFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$moduleName.labelc.log"
            $labelErrorFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$moduleName.labelc.err"
            $reportsLogFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$moduleName.ReportsC.log"
            $reportsXmlLogFile = Join-Path -Path $logDirModule -ChildPath "Dynamics.AX.$moduleName.ReportsC.xml"

            if ($OutputCommandOnly) {
                $referenceParams = @($ReferenceDir | ForEach-Object { "-referencefolder=`"$_`"" })

                $xppcParams = @("-metadata=`"$MetaDataDir`"",
                    "-modelmodule=`"$moduleName`"",
                    "-output=`"$outputDirModule\bin`"") + $referenceParams + @(
                    "-log=`"$logFile`"",
                    "-xmlLog=`"$logXmlFile`"",
                    "-verbose"
                )

                Invoke-BuildTool -Executable $xppcExecutable -Params $xppcParams -ShowOriginalProgress:$showLive -OutputCommandOnly:$OutputCommandOnly

                $labelParams = @("-metadata=`"$MetaDataDir`"",
                    "-modelmodule=`"$moduleName`"",
                    "-output=`"$outputDirModule\Resources`"",
                    "-outlog=`"$labelLogFile`"",
                    "-errlog=`"$labelErrorFile`""
                )

                Invoke-BuildTool -Executable $labelExecutable -Params $labelParams -ShowOriginalProgress:$showLive -OutputCommandOnly:$OutputCommandOnly

                if ($IncludeReports) {
                    $reportsParams = @("-metadata=`"$MetaDataDir`"",
                        "-modelmodule=`"$moduleName`"",
                        "-LabelsPath=`"$MetaDataDir`"",
                        "-output=`"$outputDirModule\Reports`"",
                        "-log=`"$reportsLogFile`"",
                        "-xmlLog=`"$reportsXmlLogFile`""
                    )

                    Invoke-BuildTool -Executable $reportsExecutable -Params $reportsParams -ShowOriginalProgress:$showLive -OutputCommandOnly:$OutputCommandOnly
                }

                continue
            }

            # Remove stale logs from previous runs, so a successful parse always reflects this run
            foreach ($staleLog in @($logFile, $logXmlFile, $labelLogFile, $labelErrorFile)) {
                if (Test-Path -LiteralPath $staleLog -PathType Leaf) {
                    Remove-Item -LiteralPath $staleLog -Force -ErrorAction SilentlyContinue
                }
            }

            if ($IncludeReports) {
                foreach ($staleLog in @($reportsLogFile, $reportsXmlLogFile)) {
                    if (Test-Path -LiteralPath $staleLog -PathType Leaf) {
                        Remove-Item -LiteralPath $staleLog -Force -ErrorAction SilentlyContinue
                    }
                }
            }

            # Stage 1: X++ compile
            $referenceParams = @($ReferenceDir | ForEach-Object { "-referencefolder=`"$_`"" })

            $xppcParams = @("-metadata=`"$MetaDataDir`"",
                "-modelmodule=`"$moduleName`"",
                "-output=`"$outputDirModule\bin`"") + $referenceParams + @(
                "-log=`"$logFile`"",
                "-xmlLog=`"$logXmlFile`"",
                "-verbose"
            )

            $xppcExitCode = Invoke-BuildTool -Executable $xppcExecutable -Params $xppcParams -ShowOriginalProgress:$showLive

            $xppcFailed = $xppcExitCode -ne 0

            $errors = @()
            $warnings = @()
            $logFailure = $null

            if (-not (Test-Path -LiteralPath $logXmlFile -PathType Leaf)) {
                if (-not $xppcFailed) {
                    $logFailure = "The compiler did not create its XML log: [$logXmlFile]"
                }
            }
            else {
                try {
                    $xml = [xml](Get-Content -LiteralPath $logXmlFile -Raw -ErrorAction Stop)
                    $diagnostics = @($xml.SelectNodes('//Diagnostic'))
                    $errors = @($diagnostics | Where-Object { $_.Severity -eq 'Error' })
                    $warnings = @($diagnostics | Where-Object { $_.Severity -eq 'Warning' })
                }
                catch {
                    $logFailure = "The compiler XML log is invalid: [$logXmlFile]"
                }
            }

            if ($null -eq $logFailure -and (Test-Path -LiteralPath $logFile -PathType Leaf) -and ($errors.Count -eq 0) -and ($xppcExitCode -eq 0)) {
                # Fall back to the text log totals when the XML log carries no diagnostics
                $textResult = Get-CompilerResult -Path $logFile

                if ($null -ne $textResult -and $textResult.Errors -gt 0) {
                    $errors = @($textResult.Errors)
                }
            }

            $errorCount = $errors.Count
            if ($errors.Count -eq 1 -and ($errors[0] -is [int])) {
                $errorCount = $errors[0]
            }

            $warningCount = $warnings.Count
            if ($warnings.Count -eq 1 -and ($warnings[0] -is [int])) {
                $warningCount = $warnings[0]
            }

            # Stage 2: labels, only when the X++ compile succeeded
            $labelExitCode = $null
            $labelFailure = $null

            $xppcOk = (-not $xppcFailed) -and ($null -eq $logFailure) -and ($errorCount -eq 0) -and ($xppcExitCode -eq 0)

            if ($xppcOk) {
                $labelParams = @("-metadata=`"$MetaDataDir`"",
                    "-modelmodule=`"$moduleName`"",
                    "-output=`"$outputDirModule\Resources`"",
                    "-outlog=`"$labelLogFile`"",
                    "-errlog=`"$labelErrorFile`""
                )

                $labelExitCode = Invoke-BuildTool -Executable $labelExecutable -Params $labelParams -ShowOriginalProgress:$showLive

                if ($labelExitCode -ne 0) {
                    $labelFailure = "[$moduleName] label compilation failed with exit code $labelExitCode. Review the label log shown below."
                }
            }

            # Stage 3: reports, only when -IncludeReports was specified and everything before succeeded
            $reportsExitCode = $null
            $reportsFailure = $null
            $reportsCompiled = $false

            if ($IncludeReports -and $xppcOk -and ($null -eq $labelFailure)) {
                $reportsParams = @("-metadata=`"$MetaDataDir`"",
                    "-modelmodule=`"$moduleName`"",
                    "-LabelsPath=`"$MetaDataDir`"",
                    "-output=`"$outputDirModule\Reports`"",
                    "-log=`"$reportsLogFile`"",
                    "-xmlLog=`"$reportsXmlLogFile`""
                )

                $reportsExitCode = Invoke-BuildTool -Executable $reportsExecutable -Params $reportsParams -ShowOriginalProgress:$showLive

                $reportsCompiled = $true

                if ($reportsExitCode -ne 0) {
                    $reportsFailure = "[$moduleName] reports compilation failed with exit code $reportsExitCode. Review the reports log shown below."
                }
            }

            $failed = $xppcFailed -or ($null -ne $logFailure) -or ($errorCount -gt 0) -or ($null -ne $labelFailure) -or ($null -ne $reportsFailure)

            if ((-not $xppcOk) -and (-not $failed)) {
                # X++ stage did not succeed, but no explicit failure was recorded (e.g. live output mode with unparsable logs)
                $failed = $true
            }

            if ($logFailure) {
                Write-PSFHostColor -String $logFailure
            }

            if ($failed -and (Test-Path -LiteralPath $logFile -PathType Leaf)) {
                $errorLines = @(Select-String -LiteralPath $logFile -Pattern "error" -SimpleMatch -CaseSensitive:$false -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Line | Where-Object { $_ -notmatch '^(Errors|Warnings):' } | Select-Object -First 25)

                foreach ($errorLine in $errorLines) {
                    Write-PSFHostColor -String $errorLine
                }
            }

            if ($labelFailure) {
                Write-PSFHostColor -String $labelFailure

                if (Test-Path -LiteralPath $labelErrorFile -PathType Leaf) {
                    $labelErrorLines = @(Get-Content -LiteralPath $labelErrorFile -ErrorAction SilentlyContinue | Select-Object -First 25)

                    foreach ($labelErrorLine in $labelErrorLines) {
                        Write-PSFHostColor -String $labelErrorLine
                    }
                }
            }

            if ($reportsFailure) {
                Write-PSFHostColor -String $reportsFailure
            }

            if ($Verbosity -ne 'None' -or $failed) {
                [PSCustomObject]@{
                    Module          = $moduleName
                    Success         = (-not $failed)
                    XppcExitCode    = $xppcExitCode
                    LabelExitCode   = $labelExitCode
                    ReportsExitCode = $reportsExitCode
                    Errors          = $errorCount
                    Warnings        = $warningCount
                    LogFile         = $logFile
                    XmlLogFile      = $logXmlFile
                    LabelOutLogFile = $labelLogFile
                    LabelErrorFile  = $labelErrorFile
                    ReportsLogFile  = $(if ($reportsCompiled) { $reportsLogFile } else { $null })
                    PSTypeName      = 'D365FO.TOOLS.ModuleBuildOutput'
                }
            }

            if ($failed) {
                $failedModules.Add($moduleName) | Out-Null
                Stop-PSFFunction -Message "[$moduleName] build failed. Review the compiler logs shown above." -Category InvalidResult -Continue
                continue
            }
        }

        if ($failedModules.Count -gt 0) {
            $names = $failedModules -join ', '
            $message = "D365 module build failed for: $names"
            $global:LASTEXITCODE = 1

            $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                [System.Exception]::new($message),
                'D365ModuleBuildFailed',
                [System.Management.Automation.ErrorCategory]::InvalidResult,
                $names
            )
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        if ($failedModules.Count -eq 0 -and $moduleInputs.Count -gt 0 -and -not $OutputCommandOnly) {
            $global:LASTEXITCODE = 0
        }

        Invoke-TimeSignal -End
    }
}