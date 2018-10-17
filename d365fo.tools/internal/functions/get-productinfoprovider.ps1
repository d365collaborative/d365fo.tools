
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
    Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.BusinessPlatform.ProductInformation.Provider.dll"
    [Microsoft.Dynamics.BusinessPlatform.ProductInformation.Provider.ProductInfoProvider]::get_Provider()
}