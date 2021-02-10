
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
    #!HACK: This can't be solved like we use to - it loads dependent assemblies based on path, when you invoke the method.
    Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.BusinessPlatform.ProductInformation.Provider.dll"

    [Microsoft.Dynamics.BusinessPlatform.ProductInformation.Provider.ProductInfoProvider]::get_Provider()
}