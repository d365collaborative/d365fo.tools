
<#
    .SYNOPSIS
        Invoke a process
        
    .DESCRIPTION
        Invoke a process and pass the needed parameters to it
        
    .PARAMETER Executable
        Path to the program / executable that you want to start
        
    .PARAMETER Params
        Array of string parameters that you want to pass to the executable
        
    .EXAMPLE
        PS C:\> Invoke-Process -Path "C:\AOSService\PackagesLocalDirectory\Bin\xppc.exe" -Params @("-metadata=`"C:\AOSService\PackagesLocalDirectory\Bin`"", "-modelmodule=`"ApplicationSuite`"", "-output=`"C:\AOSService\PackagesLocalDirectory\Bin`"", "-referencefolder=`"C:\AOSService\PackagesLocalDirectory\Bin`"", "-log=`"C:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.$Module.xppc.log`"", "-xmlLog=`"C:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.ApplicationSuite.xppc.xml`"", "-verbose")
        
        This will invoke the "C:\AOSService\PackagesLocalDirectory\Bin\xppc.exe" executable.
        All parameters will be passed to it.
        The standard output will be redirected to a local variable.
        The error output will be redirected to a local variable.
        The standard output will be written to the verbose stream before exiting.
        
        If an error should occur, both the standard output and error output will be written to the console / host.
        
    .Example
        PS C:\> Invoke-Process -ShowOriginalProgress -Path "C:\AOSService\PackagesLocalDirectory\Bin\xppc.exe" -Params @("-metadata=`"C:\AOSService\PackagesLocalDirectory\Bin`"", "-modelmodule=`"ApplicationSuite`"", "-output=`"C:\AOSService\PackagesLocalDirectory\Bin`"", "-referencefolder=`"C:\AOSService\PackagesLocalDirectory\Bin`"", "-log=`"C:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.$Module.xppc.log`"", "-xmlLog=`"C:\temp\d365fo.tools\ApplicationSuite\Dynamics.AX.ApplicationSuite.xppc.xml`"", "-verbose")
        
        This will invoke the "C:\AOSService\PackagesLocalDirectory\Bin\xppc.exe" executable.
        All parameters will be passed to it.
        The standard output will be outputted directly to the console / host.
        The error output will be outputted directly to the console / host.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-Process {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        
        [Alias('Executable')]
        [string] $Path,

        [Parameter(Mandatory = $true, Position = 2)]
        [string[]] $Params,

        [Parameter(Mandatory = $False, Position = 3 )]
        [switch] $ShowOriginalProgress
    )

    Invoke-TimeSignal -Start

    if (-not (Test-PathExists -Path $Path -Type Leaf)) {return}

    if (Test-PSFFunctionInterrupt) { return }

    $tool = Split-Path -Path $Path -Leaf

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "$Path"
    
    if (-not $ShowOriginalProgress) {
        Write-PSFMessage -Level Verbose "Output and Error streams will be redirected (silence mode)"

        $pinfo.RedirectStandardError = $true
        $pinfo.RedirectStandardOutput = $true
    }

    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = "$($Params -join " ")"
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo

    Write-PSFMessage -Level Verbose "Starting the $tool" -Target "$($params -join " ")"
    $p.Start() | Out-Null
    
    if (-not $ShowOriginalProgress) {
        $stdout = $p.StandardOutput.ReadToEnd()
        $stderr = $p.StandardError.ReadToEnd()
    }

    Write-PSFMessage -Level Verbose "Waiting for the $tool to complete"
    $p.WaitForExit()

    if ($p.ExitCode -ne 0 -and (-not $ShowOriginalProgress)) {
        Write-PSFMessage -Level Host "Exit code from $tool indicated an error happened. Will output both standard stream and error stream."
        Write-PSFMessage -Level Host "Standard output was: \r\n $stdout"
        Write-PSFMessage -Level Host "Error output was: \r\n $stderr"

        Stop-PSFFunction -Message "Stopping because an Exit Code from $tool wasn't 0 (zero) like expected." -StepsUpward 1
        return
    }
    else {
        Write-PSFMessage -Level Verbose "Standard output was: \r\n $stdout"
    }

    Invoke-TimeSignal -End
}