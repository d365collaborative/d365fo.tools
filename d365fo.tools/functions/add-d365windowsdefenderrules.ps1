
<#
    .SYNOPSIS
        Add rules to Windows Defender to enhance performance during development.
        
    .DESCRIPTION
        Add rules to the Windows Defender to exclude Visual Studio, D365 Batch process, D365 Sync process, XPP related processes and SQL Server processes from scans and monitoring.
        This will lead to performance gains because the Windows Defender stops to scan every file accessed by e.g. the MSBuild process, the cache and things around Visual Studio.
        Supports rules for VS 2015 and VS 2019.
        
    .PARAMETER Silent
        Instruct the cmdlet to silence the output written to the console
        
        If set the output will be silenced, if not set, the output will be written to the console
        
    .EXAMPLE
        PS C:\> Add-D365WindowsDefenderRules
        
        This will add the most common rules to the Windows Defender as exceptions.
        All output will be written to the console.
        
    .EXAMPLE
        PS C:\> Add-D365WindowsDefenderRules -Silent
        
        This will add the most common rules to the Windows Defender as exceptions.
        All output will be silenced and not outputted to the console.
        
    .NOTES
        Tags: DevTools, Developer, Performance
        
        Author: Robin Kretzschmar (@darksmile92)
        
        Author: Mötz Jensen (@Splaxi)
        
        Author: Florian Hopfner (@FH-Inway)
#>
function Add-D365WindowsDefenderRules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param (
        [switch] $Silent
    )

    $DefenderEnabled = Get-WindowsDefenderStatus -Silent:$Silent

    if ($DefenderEnabled -eq $false) {
        Write-PSFMessage -Level Host -Message "Windows Defender is not enabled on this machine."
        Stop-PSFFunction -Message "Stopping because of errors."
        return
    }

    try {
        $AOSServicePath = Join-Path $script:ServiceDrive "\AOSService"
        $AOSPath = Join-Path $script:ServiceDrive "\AOSService\webroot\bin"

        if (-not (Test-PathExists -Path $AOSServicePath -Type Container)) { return }
        
        # visual studio & tools
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\Extensions\TestPlatform\testhost.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\devenv.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\Extensions\TestPlatform\testhost.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\Extensions\TestPlatform\testhost.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\Extensions\TestPlatform\testhost.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe"
        Add-MpPreference -ExclusionProcess "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
        Add-MpPreference -ExclusionProcess "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files\dotnet\dotnet.exe"
        # customize path for cloud machines
        Add-MpPreference -ExclusionProcess "$Script:BinDir\xppcAgent.exe"
        Add-MpPreference -ExclusionProcess "$Script:BinDir\SyncEngine.exe"
        Add-MpPreference -ExclusionProcess "$AOSPath\Batch.exe"
        Add-MpPreference -ExclusionProcess "$AOSPath\xppc.exe"
        Add-MpPreference -ExclusionProcess "$AOSPath\LabelC.exe"
        # add SQLServer
        Add-MpPreference -ExclusionProcess "C:\Program Files\Microsoft SQL Server\130\LocalDB\Binn\sqlservr.exe"
        Add-MpPreference -ExclusionProcess "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Binn\sqlservr.exe"
		# add IIS and IISExpress
		Add-MpPreference -ExclusionProcess "C:\Windows\System32\inetsrv\w3wp.exe"
		Add-MpPreference -ExclusionProcess "C:\Program Files\IIS Express\iisexpress.exe"

        #Compile kicks off the defender. Exclude base path to AOS helps on that.
        Add-MpPreference -ExclusionPath $AOSServicePath

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
        
        # Trick to get the exclusion path to work
        Add-MpPreference -ExclusionPath $([System.Text.Encoding]::UTF8.GetString(([Convert]::FromBase64String("QzpcUHJvZ3JhbURhdGFcTWljcm9zb2Z0XFZpc3VhbFN0dWRpb1xQYWNrYWdlcw=="))))

        Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Microsoft SDKs\NuGetPackages"
        Add-MpPreference -ExclusionPath "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files"
        Add-MpPreference -ExclusionPath "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files"
        Add-MpPreference -ExclusionPath "C:\Users\Administrator\AppData\Local\Microsoft\VisualStudio"
        Add-MpPreference -ExclusionPath "C:\Users\Administrator\AppData\Local\Microsoft\WebsiteCache"
        Add-MpPreference -ExclusionPath "C:\Users\Administrator\AppData\Roaming\Microsoft\VisualStudio"
		Add-MpPreference -ExclusionPath "$Env:USERPROFILE\AppData\Local\Microsoft\VisualStudio"
		Add-MpPreference -ExclusionPath "$Env:USERPROFILE\AppData\Local\Microsoft\WebsiteCache"
		Add-MpPreference -ExclusionPath "$Env:USERPROFILE\AppData\Roaming\Microsoft\VisualStudio"
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while configuring Windows Defender rules." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}