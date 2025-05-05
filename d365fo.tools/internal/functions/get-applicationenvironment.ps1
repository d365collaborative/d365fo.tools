
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
    $isUDE = $false
    if (-not (Test-Path -Path $AOSPath -PathType Container)) {
        Write-PSFMessage -Level Verbose -Message "The machine is NOT an AOS server."
        
        $MRPath = Join-Path $script:ServiceDrive "MRProcessService\MRInstallDirectory\Server\Services"
        
        Write-PSFMessage -Level Verbose -Message "Testing if we are running on a BI / MR server or not."
        if (-not (Test-Path -Path $MRPath -PathType Container)) {
            Write-PSFMessage -Level Verbose -Message "The machine is NOT a BI/MR server"
            $RegSplat = @{
                Path = "HKCU:\Software\Microsoft\Dynamics\AX7\Development\Configurations"
                Name = "FrameworkDirectory"
            }
            $frameworkDirectoryRegValue = $( if (Test-RegistryValue @RegSplat) { Get-ItemPropertyValue @RegSplat } else { "" } )
            $BasePath = Join-Path $frameworkDirectoryRegValue "bin"
            if (-not (Test-Path -Path $BasePath -PathType Container)) {
                Write-PSFMessage -Level Verbose -Message "It seems that you ran this cmdlet on a machine that doesn't have the assemblies needed to obtain system details. Most likely you ran it on a <c='em'>personal workstation / personal computer</c>."
                return
            }
            Write-PSFMessage -Level Verbose -Message "The machine is a unified development environment"
            $isUDE = $true
            $null = $Files2Process.Add((Join-Path $BasePath "Microsoft.Dynamics.AX.Authentication.Instrumentation.dll"))
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
    if ($isUDE) {
        # In case of unified development environments, the system information returned by the assemblies is lacking.
        # In this case, the .NET object gets replaced with a PowerShell object that contains the necessary information.
        $environment = Initialize-UnifiedDevelopmentEnvironment -environment $environment
    }
    
    $environment
}

function Initialize-UnifiedDevelopmentEnvironment {
    [CmdletBinding()]
    param (
        [Object]
        $environment
    )

    $RegSplat = @{
        Path = "HKCU:\Software\Microsoft\Dynamics\AX7\Development\Configurations"
        Name = "FrameworkDirectory"
    }
    $frameworkDirectoryRegValue = $( if (Test-RegistryValue @RegSplat) { Get-ItemPropertyValue @RegSplat } else { "" } )
    $RegSplat.Name = "CurrentMetadataConfig"
    $metadataConfigFileRegValue = $( if (Test-RegistryValue @RegSplat) { Get-ItemPropertyValue @RegSplat } else { "" } )    
    $metadataConfig = Get-Content -Path $metadataConfigFileRegValue -Raw | ConvertFrom-Json

    $psEnvironment = New-Object -TypeName PSObject -Property @{
        Aad = @{
            TenantDomainGUID = $environment.Aad.TenantDomainGUID # TODO mapped to $Script.TenantId
        }
        Aos = @{
            AppRoot = $environment.Aos.AppRoot # TODO mapped to $Script.AOSPath; is usually */AOSService/webroot
            PackageDirectory = $frameworkDirectoryRegValue # aka the PackagesLocalDirectory
            MetadataDirectory = $metadataConfig.ModelStoreFolder # TODO on UDE, this is different from the PackagesLocalDirectory
        }
        DataAccess = @{
            # TODO all values are empty on UDE
            DbServer = $environment.DataAccess.DbServer
            Database = $environment.DataAccess.Database
            SqlUser = $environment.DataAccess.SqlUser
            SqlPwd = $environment.DataAccess.SqlPwd
        }
        Common = @{
            BinDir = $frameworkDirectoryRegValue # aka the PackagesLocalDirectory
            DevToolsBinDir = $frameworkDirectoryRegValue + '\bin'
            IsOneboxEnvironment = $true # TODO check what this controls, maybe $false is better for UDE?
        }
        Monitoring = @{
            MARole = $environment.Monitoring.MARole
        }
        Infrastructure = @{
            HostName = "UnifiedDevelopmentEnvironment" # TODO Ugly solution to identify UDE
            HostUrl = $environment.Infrastructure.HostUrl
        }
    }

    $psEnvironment
}