
<#
    .SYNOPSIS
        Get the instance provider from the D365FO instance
        
    .DESCRIPTION
        Get the instance provider from the dll files used for encryption and authentication for D365FO
        
    .EXAMPLE
        PS C:\> Get-InstanceIdentityProvider
        
        This will return the Instance Identity Provider based on the D365FO instance.
        
    .NOTES
        Author : Rasmus Andersen (@ITRasmus)
        Author : Mötz Jensen (@splaxi)
        
#>
function Get-InstanceIdentityProvider {
    [CmdletBinding()]
    [OutputType([System.String])]
    
    param()

    $files = @("$Script:AOSPath\bin\Microsoft.Dynamics.AX.Framework.EncryptionEngine.dll",
        "$Script:AOSPath\bin\Microsoft.Dynamics.AX.Security.AuthenticationCommon.dll")

    if (-not (Test-PathExists -Path $files -Type Leaf)) {
        return
    }

    try {
        Add-Type -Path $files

        $Identity = [Microsoft.Dynamics.AX.Security.AuthenticationCommon.AadHelper]::GetIdentityProvider()
        
        Write-PSFMessage -Level Verbose -Message "The found instance identity provider is: $Identity" -Target $Identity

        $Identity
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the Identity provider" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}