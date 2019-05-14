<#
.SYNOPSIS
Set the needed configuration to work on Tier2+ environments

.DESCRIPTION
Set the needed registry settings for when you are running RSAT against a Tier2+ environment

.EXAMPLE
PS C:\> Set-D365RsatTier2Crypto

This will configure the registry to support RSAT against a Tier2+ environment.

.NOTES
Tags: Automated Test, Test, Regression, Certificate, Thumbprint
Author: Mötz Jensen (@Splaxi)

#>

function Set-D365RsatTier2Crypto {
    [CmdletBinding()]
    [OutputType()]
    param ()
    
    if ((Test-Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319")) {
        Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name SchUseStrongCrypto -Value 1 -Type dword -Force -Confirm:$false
    }
}