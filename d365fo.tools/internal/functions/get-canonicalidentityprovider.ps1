
<#
    .SYNOPSIS
        Load the Canonical Identity Provider
        
    .DESCRIPTION
        Load the necessary dll files from the D365 instance to get the Canonical Identity Provider object
        
    .EXAMPLE
        PS C:\> Get-CanonicalIdentityProvider
        
        This will get the Canonical Identity Provider from the D365 instance
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-CanonicalIdentityProvider {
    [CmdletBinding()]
    param ()
    try {
        Write-PSFMessage -Level Verbose "Loading dll files to do some work against the CanonicalIdentityProvider."

        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.AX.Framework.EncryptionEngine.dll"
        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.AX.Security.AuthenticationCommon.dll"

        Write-PSFMessage -Level Verbose "Executing the CanonicalIdentityProvider lookup logic."
        $Identity = [Microsoft.Dynamics.AX.Security.AuthenticationCommon.AadHelper]::GetIdentityProvider()
        $Provider = [Microsoft.Dynamics.AX.Security.AuthenticationCommon.AadHelper]::GetCanonicalIdentityProvider($Identity)

        Write-PSFMessage -Level Verbose "CanonicalIdentityProvider is: $Provider" -Tag $Provider

        return $Provider
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the CanonicalIdentityProvider." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}