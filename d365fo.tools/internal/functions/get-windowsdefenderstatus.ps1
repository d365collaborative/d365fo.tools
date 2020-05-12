
<#
    .SYNOPSIS
        Get Windows Defender Status
        
    .DESCRIPTION
        Will get the current status of the Windows Defender
        
    .PARAMETER Silent
        Instruct the cmdlet to silence the output written to the console
        
        If set the output will be silenced, if not set, the output will be written to the console
        
    .EXAMPLE
        PS C:\> Get-WindowsDefenderStatus
        
        This will get the status of Windows Defender.
        It will write the output to the console.
        
    .EXAMPLE
        PS C:\> Get-WindowsDefenderStatus -Silent
        
        This will get the status of Windows Defender.
        All outputs will be silenced.
        
    .NOTES
        Inspired by https://gallery.technet.microsoft.com/scriptcenter/PowerShell-to-Check-if-811b83bc
        
        Author: Robin Kretzschmar (@darksmile92)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-WindowsDefenderStatus {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
        [switch] $Silent
    )
    try {
        $defenderOptions = Get-MpComputerStatus
     
        if ([string]::IsNullOrEmpty($defenderOptions)) {
            if ($Silent -eq $false) {
                Write-PSFMessage -Level Host -Message "Windows Defender was not found running on the Server: $($env:computername)"
            }

            $false
        }
        else {
            if ($Silent -eq $false) {
                Write-PSFHostColor -DefaultColor "Cyan" -String "Windows Defender was found on the Server: $($env:computername)"
                Write-PSFHostColor -DefaultColor "Yellow" -String "   Is Windows Defender Enabled? $($defenderOptions.AntivirusEnabled)"
                Write-PSFHostColor -DefaultColor "Yellow" -String "   Is Windows Defender Service Enabled? $($defenderOptions.AMServiceEnabled)"
                Write-PSFHostColor -DefaultColor "Yellow" -String "   Is Windows Defender Antispyware Enabled? $($defenderOptions.AntispywareEnabled)"
                Write-PSFHostColor -DefaultColor "Yellow" -String "   Is Windows Defender OnAccessProtection Enabled? $($defenderOptions.OnAccessProtectionEnabled)"
                Write-PSFHostColor -DefaultColor "Yellow" -String "   Is Windows Defender RealTimeProtection Enabled? $($defenderOptions.RealTimeProtectionEnabled)"
            }
            if ($defenderOptions.AntivirusEnabled -eq $true) {
                $true
            }
            else {
                $false
            }
        }
    }
    catch {
        if ($Silent -eq $false) {
            Write-PSFMessage -Level Host -Message "Windows Defender was not found running on the Server: $($env:computername)"
        }

        $false
    }
}