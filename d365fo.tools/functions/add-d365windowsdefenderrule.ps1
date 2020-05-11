<#
    .SYNOPSIS
        Add rules to Windows Defender to enhance performance during development.
        
    .DESCRIPTION
        Add rules to the Windows Defender to exclude Visual Studio, D365 Batch process, D365 Sync process, XPP related processes and SQL Server processes from scans and monitoring.
        This will lead to performance gains because the Windows Defender stops to scan every file accessed by e.g. the MSBuild process, the cache and things around Visual Studio.
        Supports rules for VS 2015 and VS 2019.
        
    .PARAMETER CertificateThumbprint
        The thumbprint value of the certificate that you want to register in the wif.config file
        
    .EXAMPLE
        PS C:\> Add-D365WindowsDefenderRules
        
        This will add the most common rules to the Windows Defender as exceptions.
        
    .NOTES
        Tags: ???
        
        Author: Robin Kretzschmar (@darksmile92)
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-WindowsDefenderStatus {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [boolean] $Silent
    )
    # inspired by https://gallery.technet.microsoft.com/scriptcenter/PowerShell-to-Check-if-811b83bc
    try 
    { 
        $defenderOptions = Get-MpComputerStatus 
     
        if([string]::IsNullOrEmpty($defenderOptions)) 
        { 
            if ($Silent -eq $false) {
                Write-host "Windows Defender was not found running on the Server:" $env:computername -foregroundcolor "Green" 
            }
            return $false
        } 
        else 
        { 
            if  ($Silent -eq $false) {
                Write-host "Windows Defender was found on the Server:" $env:computername -foregroundcolor "Cyan"
                Write-host "   Is Windows Defender Enabled?" $defenderOptions.AntivirusEnabled
                Write-host "   Is Windows Defender Service Enabled?" $defenderOptions.AMServiceEnabled
                Write-host "   Is Windows Defender Antispyware Enabled?" $defenderOptions.AntispywareEnabled
                Write-host "   Is Windows Defender OnAccessProtection Enabled?"$defenderOptions.OnAccessProtectionEnabled
                Write-host "   Is Windows Defender RealTimeProtection Enabled?"$defenderOptions.RealTimeProtectionEnabled
            }
            if ($defenderOptions.AntivirusEnabled -eq $true) {
                return $true
            } else {
                return $false
            }
        } 
    } 
    catch 
    { 
        if  ($Silent -eq $false) {
            Write-host "Windows Defender was not found running on the Server:" $env:computername -foregroundcolor "Green" 
        }
        return $false
    }
}

function Add-D365WindowsDefenderRules {

    $DefenderEnabled = Get-WindowsDefenderStatus $false

    if ($DefenderEnabled -eq $false) {
        Write-PSFMessage -Level Host -Message "Windows Defender is not enabled on this maschine." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors." -StepsUpward 1
    }

    try
    {
        $AOSServicePath = Join-Path $script:ServiceDrive "\AOSService"
        $AOSPath = Join-Path $script:ServiceDrive "\AOSService\webroot\bin"
        if($true -eq (Test-Path -Path $AOSServicePath))
        {
            # visual studio & tools
            Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe"
            Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"
            Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe"
            Add-MpPreference -ExclusionProcess "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
            Add-MpPreference -ExclusionProcess "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"
            Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe"
            Add-MpPreference -ExclusionProcess "C:\Program Files\dotnet\dotnet.exe"
            # customize path for cloud maschines
            Add-MpPreference -ExclusionProcess "$Script:BinDir\xppcAgent.exe"
            Add-MpPreference -ExclusionProcess "$Script:BinDir\SyncEngine.exe"
            Add-MpPreference -ExclusionProcess "$AOSPath\Batch.exe"
            # add SQLServer
            Add-MpPreference -ExclusionProcess "C:\Program Files\Microsoft SQL Server\130\LocalDB\Binn\sqlservr.exe"
            Add-MpPreference -ExclusionProcess "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Binn\sqlservr.exe"


            # cache folders

            Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Microsoft Visual Studio 10.0"
            Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Microsoft Visual Studio 14.0"
            Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Microsoft Visual Studio"
            Add-MpPreference -ExclusionPath "C:\Windows\assembly"
            Add-MpPreference -ExclusionPath "C:\Windows\Microsoft.NET"
            Add-MpPreference -ExclusionPath "C:\Program Files (x86)\MSBuild"
            Add-MpPreference -ExclusionPath "C:\Program Files\dotnet"
            Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Microsoft SDKs"
            Add-MpPreference -ExclusionPath "C:\Program Files\Microsoft SDKs"
            Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Common Files\Microsoft Shared\MSEnv"
            Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Microsoft Office"
            Add-MpPreference -ExclusionPath "C:\ProgramData\Microsoft\VisualStudio\Packages"
            Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Microsoft SDKs\NuGetPackages"
            Add-MpPreference -ExclusionPath "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files"
            Add-MpPreference -ExclusionPath "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files"
            Add-MpPreference -ExclusionPath "C:\Users\Administrator\AppData\Local\Microsoft\VisualStudio"
            Add-MpPreference -ExclusionPath "C:\Users\Administrator\AppData\Local\Microsoft\WebsiteCache"
            Add-MpPreference -ExclusionPath "C:\Users\Administrator\AppData\Roaming\Microsoft\VisualStudio"
        } else 
        {
            Write-PSFMessage -Level Critical -Message "The AOSService directory could not be located under drive $script:ServiceDrive."
            Stop-PSFFunction -Message  "Stopping because the AOSService directory could not be located."
            return
        }
    }
    catch
    {
        Write-PSFMessage -Level Host -Message "Something went wrong while configuring Windows Defender rules." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }
}