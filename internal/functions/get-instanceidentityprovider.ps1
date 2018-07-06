
function Get-InstanceIdentityProvider {

    try {
        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.AX.Framework.EncryptionEngine.dll"
        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.AX.Security.AuthenticationCommon.dll"

        $Identity = [Microsoft.Dynamics.AX.Security.AuthenticationCommon.AadHelper]::GetIdentityProvider()
        Write-Verbose $Identity
        return  $Identity

    }
    catch [System.Reflection.ReflectionTypeLoadException] {
        Write-Output "Message: $($_.Exception.Message)"
        Write-Output "StackTrace: $($_.Exception.StackTrace)"
        Write-Output "LoaderExceptions: $($_.Exception.LoaderExceptions)"
    }
}