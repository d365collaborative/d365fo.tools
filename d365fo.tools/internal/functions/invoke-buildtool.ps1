
<#
    .SYNOPSIS
        Invoke a compiler executable quietly and return its exit code
        
    .DESCRIPTION
        Minimal process runner for Invoke-D365ModuleBuild.
        
        Unlike Invoke-Process it never writes the standard output or error
        streams to the console. They are discarded, because the compiler log
        files are the source of truth and the caller parses those for the
        agent friendly summary.
        
        It returns the numeric exit code of the executable, so the caller can
        signal success or failure without any console noise.
        
    .PARAMETER Executable
        Full path to the program / executable that you want to start
        
    .PARAMETER Params
        Array of string parameters that you want to pass to the executable
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to let the standard output stream live to the console
        
        Default is $false which will discard the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .EXAMPLE
        PS C:\> Invoke-BuildTool -Executable "C:\AOSService\PackagesLocalDirectory\bin\xppc.exe" -Params "-metadata=`"C:\AOSService\PackagesLocalDirectory`"", "-verbose"
        
        This will invoke the xppc.exe executable with discarded output.
        It will return the numeric exit code of the executable.
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
#>
function Invoke-BuildTool {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Executable,

        [Parameter(Mandatory = $true)]
        [string[]] $Params,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    $arguments = $Params -join " "

    if ($OutputCommandOnly) {
        Write-PSFMessage -Level Host -Message "$Executable $arguments"
        return
    }

    $tool = Split-Path -Path $Executable -Leaf

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $Executable
    $pinfo.WorkingDirectory = Split-Path -Path $Executable -Parent
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $arguments

    if (-not $ShowOriginalProgress) {
        $pinfo.RedirectStandardError = $true
        $pinfo.RedirectStandardOutput = $true
    }

    Write-PSFMessage -Level Verbose -Message "Starting the $tool" -Target $arguments

    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo

    $p.Start() | Out-Null

    if (-not $ShowOriginalProgress) {
        # Drain the streams asynchronously and discard them.
        # The compiler log files carry the diagnostics, not the console.
        $outTask = $p.StandardOutput.ReadToEndAsync()
        $errTask = $p.StandardError.ReadToEndAsync()
    }

    Write-PSFMessage -Level Verbose -Message "Waiting for the $tool to complete"
    $p.WaitForExit()

    if (-not $ShowOriginalProgress) {
        $null = $outTask.Result
        $null = $errTask.Result
    }

    Write-PSFMessage -Level Verbose -Message "Exit code from $tool was: $($p.ExitCode)"

    $p.ExitCode
}