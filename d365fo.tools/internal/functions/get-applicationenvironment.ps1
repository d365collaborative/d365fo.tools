
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
    $AOSPath = Join-Path $script:ServiceDrive "\AOSService\webroot\bin"
    
    Write-PSFMessage -Level Verbose -Message "Testing if we are running on a AOS server or not"
    if (-not (Test-Path -Path $AOSPath -PathType Container)) {
        $AOSPath = Join-Path $script:ServiceDrive "MRProcessService\MRInstallDirectory\Server\Services"

        Write-PSFMessage -Level Verbose -Message "Testing if we are running on a BI / MR server or not"
        if (-not (Test-Path -Path $AOSPath -PathType Container)) {
            Write-PSFMessage -Level Verbose -Message "It seems that you ran this cmdlet on a machine that doesn't have the assemblies needed to obtain system details. Most likely you ran it on a <c='em'>personal workstation / personal computer</c>."
            return
        }
    }

    $break = $false

    Write-PSFMessage -Level Verbose -Message "Shadow cloning all relevant assemblies to the Microsoft.Dynamics.ApplicationPlatform.Environment.dll to avoid locking issues. This enables us to install updates while having d365fo.tools loaded"

    $BasePath = "$AOSPath"
    [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"
        
    $null = $Files2Process.Add("Microsoft.Dynamics.AX.Authentication.Instrumentation")
    $null = $Files2Process.Add("Microsoft.Dynamics.AX.Configuration.Base")
    $null = $Files2Process.Add("Microsoft.Dynamics.BusinessPlatform.SharedTypes")
    $null = $Files2Process.Add("Microsoft.Dynamics.AX.Framework.EncryptionEngine")
    $null = $Files2Process.Add("Microsoft.Dynamics.AX.Security.Instrumentation")
    $null = $Files2Process.Add("Microsoft.Dynamics.ApplicationPlatform.Environment")
        
    foreach ($name in $Files2Process) {
            
        $ShadowClone = Join-Path $BasePath "$name`_shadow.dll"
        $Path = Join-Path $BasePath "$name.dll"
            
        if (Test-Path -Path $Path -PathType Leaf) {
            Copy-Item -Path $Path -Destination $ShadowClone -Force

            $null = [AppDomain]::CurrentDomain.Load(([System.IO.File]::ReadAllBytes($ShadowClone)))

            Remove-Item -Path $ShadowClone -Force
        }
        else {
            Write-PSFMessage -Level Verbose -Message "Unable to load all needed files. Setting break variable."

            $break = $true
            break
        }
    }

    if ($break -eq $false) {
        Write-PSFMessage -Level Verbose -Message "All assemblies loaded. Getting environment details."
        $environment = [Microsoft.Dynamics.ApplicationPlatform.Environment.EnvironmentFactory]::GetApplicationEnvironment()
    }
    
    $environment
}