function Invoke-Process {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $Executable,

        [Parameter(Mandatory = $true, Position = 2)]
        [string[]] $Params
    )

    if (-not (Test-PathExists -Path $Executable -Type Leaf)) {return}

    if (Test-PSFFunctionInterrupt) { return }

    $tool = Split-Path -Path $Executable -Leaf

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "$Executable"
    
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
    }
    else {
        Write-PSFMessage -Level Verbose "Standard output was: \r\n $stdout"
    }
}