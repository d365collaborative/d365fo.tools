
<#
    .SYNOPSIS
        Get the ClickOnce configuration
        
    .DESCRIPTION
        Creates the needed registry keys and values for ClickOnce to work on the machine
        
    .EXAMPLE
        PS C:\> Get-D365ClickOnceTrustPrompt
        
        This will get the current ClickOnce configuration
        
    .NOTES
        Tags: ClickOnce, Registry, TrustPrompt
        
        Author: Mötz Jensen (@Splaxi)
#>
function Get-D365ClickOnceTrustPrompt {
    [CmdletBinding()]
    param (
    
    )
    
    begin {
    }
    
    process {
        Write-PSFMessage -Level Verbose -Message "Testing if the registry key exists or not"

        if ((Test-Path -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel") -eq $false) {
            Write-PSFMessage -Level Host -Message "It looks like ClickOnce trust prompt has never been configured on this machine. Run Set-D365ClickOnceTrustPrompt to fix that"
        }
        else {
            Write-PSFMessage -Level Verbose -Message "Gathering the details from registry"

            [PSCustomObject]@{
                UntrustedSites = (Get-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" "UntrustedSites").UntrustedSites
                Internet       = (Get-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" "Internet").Internet
                MyComputer     = (Get-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" "MyComputer").MyComputer
                LocalIntranet  = (Get-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" "LocalIntranet").LocalIntranet
                TrustedSites   = (Get-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" "TrustedSites").TrustedSites
            }
        }

    }
    
    end {
    }
}