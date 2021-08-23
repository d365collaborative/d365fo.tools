
<#
    .SYNOPSIS
        Load all necessary information about the D365 instance
        
    .DESCRIPTION
        Load all servicing dll files from the D365 instance into memory
        
    .EXAMPLE
        PS C:\> Get-ApplicationEnvironment
        
        This will load all the different dll files into memory.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-ApplicationEnvironment {
    [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"

    $AOSPath = Join-Path $script:ServiceDrive "\AOSService\webroot\bin"
    
    Write-PSFMessage -Level Verbose -Message "Testing if we are running on a AOS server or not."
    if (-not (Test-Path -Path $AOSPath -PathType Container)) {
        Write-PSFMessage -Level Verbose -Message "The machine is NOT an AOS server."
        
        $MRPath = Join-Path $script:ServiceDrive "MRProcessService\MRInstallDirectory\Server\Services"
        
        Write-PSFMessage -Level Verbose -Message "Testing if we are running on a BI / MR server or not."
        if (-not (Test-Path -Path $MRPath -PathType Container)) {
            Write-PSFMessage -Level Verbose -Message "It seems that you ran this cmdlet on a machine that doesn't have the assemblies needed to obtain system details. Most likely you ran it on a <c='em'>personal workstation / personal computer</c>."
            return
        }
        else {
            Write-PSFMessage -Level Verbose -Message "The machine is a BI / MR server."
            $BasePath = $MRPath

            $null = $Files2Process.Add((Join-Path $script:ServiceDrive "Monitoring\Instrumentation\Microsoft.Dynamics.AX.Authentication.Instrumentation.dll"))
        }
    }
    else {
        Write-PSFMessage -Level Verbose -Message "The machine is an AOS server."
        $BasePath = $AOSPath

        $null = $Files2Process.Add((Join-Path $BasePath "Microsoft.Dynamics.AX.Authentication.Instrumentation.dll"))
    }

    Write-PSFMessage -Level Verbose -Message "Shadow cloning all relevant assemblies to the Microsoft.Dynamics.ApplicationPlatform.Environment.dll to avoid locking issues. This enables us to install updates while having d365fo.tools loaded"
        
    $null = $Files2Process.Add((Join-Path $BasePath "Microsoft.Dynamics.AX.Configuration.Base.dll"))
    $null = $Files2Process.Add((Join-Path $BasePath "Microsoft.Dynamics.BusinessPlatform.SharedTypes.dll"))
    $null = $Files2Process.Add((Join-Path $BasePath "Microsoft.Dynamics.AX.Framework.EncryptionEngine.dll"))
    $null = $Files2Process.Add((Join-Path $BasePath "Microsoft.Dynamics.AX.Security.Instrumentation.dll"))
    $null = $Files2Process.Add((Join-Path $BasePath "Microsoft.Dynamics.ApplicationPlatform.Environment.dll"))

    Import-AssemblyFileIntoMemory -Path $($Files2Process.ToArray()) -UseTempFolder

    if (Test-PSFFunctionInterrupt) { return }

    Write-PSFMessage -Level Verbose -Message "All assemblies loaded. Getting environment details."
    $environment = [Microsoft.Dynamics.ApplicationPlatform.Environment.EnvironmentFactory]::GetApplicationEnvironment()
    
    $environment
}