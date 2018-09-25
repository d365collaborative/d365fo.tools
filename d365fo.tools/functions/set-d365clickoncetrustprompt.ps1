<#
.SYNOPSIS
Set the ClickOnce needed configuration

.DESCRIPTION
Creates the needed registry keys and values for ClickOnce to work on the machine

.EXAMPLE
Set-D365ClickOnceTrustPrompt

This will create / or update the current ClickOnce configuration
.NOTES
General notes
#>
function Set-D365ClickOnceTrustPrompt {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param ( )
    
    begin { }
    
    process {
        Write-PSFMessage -Level Verbose -Message "Testing if the registry key exists or not"        

        if ((Test-Path -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel") -eq $false) {
            Write-PSFMessage -Level Verbose -Message "Registry key was not found. Will create it now."
            $null = New-Item -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager" -Name "PromptingLevel" -Force
        }        
        
        Write-PSFMessage -Level Verbose -Message "Setting all necessary registry keys."

        Set-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" -Name "UntrustedSites" -Type STRING -Value "Disabled" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" -Name "Internet" -Type STRING -Value "Enabled" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" -Name "MyComputer" -Type STRING -Value "Enabled" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" -Name "LocalIntranet" -Type STRING -Value "Enabled" -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" -Name "TrustedSites" -Type STRING -Value "Enabled" -Force
    }
    
    end { }
}