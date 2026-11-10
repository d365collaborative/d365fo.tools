<#
    .SYNOPSIS
        Register D365FO Event Trace Providers

    .DESCRIPTION
        Register event manifests from the AOS Monitoring directory to restore missing Event Trace Providers for Dynamics 365 for Finance and Operations.

        Existing providers are registered again. Each manifest uses the first matching resource DLL in this order: .Instrumentation.dll, Resource.dll, .dll.

        Run from an elevated PowerShell session on the D365FO server. Restart the VM after registration before starting a trace.

    .PARAMETER Path
        Path to the Monitoring directory containing the event manifests and resource DLLs.

        Defaults to the Monitoring directory below the configured AOS application root.

    .PARAMETER EnableException
        Disable user-friendly warnings and throw exceptions that can be caught by calling scripts.

    .PARAMETER WhatIf
        Show which event manifests would be registered without changing the installed providers.

    .PARAMETER Confirm
        Prompt for confirmation before registering each event manifest.

    .EXAMPLE
        PS C:\> Register-D365EventTraceProvider

        Register the event manifests from the configured AOS Monitoring directory.
        Restart the VM afterwards before starting a trace.

    .EXAMPLE
        PS C:\> Register-D365EventTraceProvider -Path "K:\AosService\WebRoot\Monitoring" -WhatIf

        Show which event manifests would be registered from the specified Monitoring directory.
        No providers are changed.

    .NOTES
        Tags: ETL, EventTracing, EventTrace, Monitoring

        Based on the troubleshooting guidance published by Automaly.

    .LINK
        https://automaly.com/posts/unable-to-trace-error/
#>
function Register-D365EventTraceProvider {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [ValidateNotNullOrEmpty()]
        [string] $Path = (Join-Path -Path $Script:AOSPath -ChildPath "Monitoring"),

        [switch] $EnableException
    )

    if (-not $Script:IsAdminRuntime) {
        Stop-PSFFunction -Message "Elevated permissions needed. Please start an elevated session and run the cmdlet again." -EnableException $EnableException
        return
    }

    try {
        if (-not (Test-PathExists -Path $Path -Type Container -ErrorAction Stop)) { return }

        $executable = Join-Path -Path $env:SystemRoot -ChildPath "System32\wevtutil.exe"
        if (-not (Test-PathExists -Path $executable -Type Leaf -ErrorAction Stop)) { return }
    }
    catch {
        Stop-PSFFunction -Message "Unable to access the Monitoring directory or wevtutil.exe." -ErrorRecord $_ -EnableException $EnableException
        return
    }

    try {
        $manifests = @(Get-ChildItem -LiteralPath $Path -Filter "*.man" -File -ErrorAction Stop)
    }
    catch {
        Stop-PSFFunction -Message "Unable to read event manifests from '$Path'." -ErrorRecord $_ -EnableException $EnableException
        return
    }

    if ($manifests.Count -eq 0) {
        Stop-PSFFunction -Message "No event manifests were found in '$Path'." -EnableException $EnableException
        return
    }

    $registered = 0
    foreach ($manifest in $manifests) {
        $dllFile = $null
        foreach ($suffix in @(".Instrumentation.dll", "Resource.dll", ".dll")) {
            $candidate = Join-Path -Path $manifest.DirectoryName -ChildPath "$($manifest.BaseName)$suffix"
            if (Test-Path -LiteralPath $candidate -PathType Leaf) {
                $dllFile = $candidate
                break
            }
        }

        if (-not $dllFile) {
            Write-PSFMessage -Level Warning -Message "Skipping '$($manifest.FullName)' because no matching resource DLL was found." -Target $manifest.FullName
            continue
        }

        if ($PSCmdlet.ShouldProcess($manifest.FullName, "Register event trace providers using '$dllFile'")) {
            $params = @("im", "`"$($manifest.FullName)`"", "/rf:`"$dllFile`"", "/mf:`"$dllFile`"")
            try {
                $result = Invoke-Process -Path $executable -Params $params -EnableException
            }
            catch {
                Stop-PSFFunction -Message "Unable to register event manifest '$($manifest.FullName)'." -ErrorRecord $_ -EnableException $EnableException
                return
            }

            if ($null -eq $result -or $result.ExitCode -ne 0) {
                Stop-PSFFunction -Message "Registration of event manifest '$($manifest.FullName)' did not complete successfully." -EnableException $EnableException
                return
            }

            $registered++
            Write-PSFMessage -Level Verbose -Message "Registered event manifest '$($manifest.FullName)' using '$dllFile'." -Target $manifest.FullName
        }
    }

    if ($registered -gt 0) {
        Write-PSFMessage -Level Host -Message "Registered $registered event manifest(s). Restart the VM before starting a trace."
    }
}
