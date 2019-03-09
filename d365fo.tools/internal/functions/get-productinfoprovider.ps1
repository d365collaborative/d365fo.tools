
<#
    .SYNOPSIS
        Get the product information
        
    .DESCRIPTION
        Get the product information object from the environment
        
    .EXAMPLE
        PS C:\> Get-ProductInfoProvider
        
        This will get the product information object and return it
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-ProductInfoProvider {
    [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"

    $null = $Files2Process.Add($(Join-Path "$Script:AOSPath" "bin\Microsoft.Dynamics.ApplicationPlatform.Services.Instrumentation.dll"))
    $null = $Files2Process.Add($(Join-Path "$Script:AOSPath" "BIN\PRODUCTINFO\MICROSOFT.DYNAMICS.BUSINESSPLATFORM.PRODUCTINFORMATION.APPLICATION.dll"))
    $null = $Files2Process.Add($(Join-Path "$Script:AOSPath" "bin\Microsoft.Dynamics.BusinessPlatform.ProductInformation.Framework.dll"))
    $null = $Files2Process.Add($(Join-Path "$Script:AOSPath" "BIN\PRODUCTINFO\MICROSOFT.DYNAMICS.BUSINESSPLATFORM.PRODUCTINFORMATION.PLATFORM.dll"))
    $null = $Files2Process.Add($(Join-Path "$Script:AOSPath" "BIN\PRODUCTINFO\MICROSOFT.DYNAMICS.BUSINESSPLATFORM.PRODUCTINFORMATION.PRODUCTBUILD.dll"))
    $null = $Files2Process.Add($(Join-Path "$Script:AOSPath" "bin\Microsoft.Dynamics.BusinessPlatform.ProductInformation.Provider.dll"))

    Import-AssemblyFileIntoMemory -Path $($Files2Process.ToArray())

    [Microsoft.Dynamics.BusinessPlatform.ProductInformation.Provider.ProductInfoProvider]::get_Provider()
}