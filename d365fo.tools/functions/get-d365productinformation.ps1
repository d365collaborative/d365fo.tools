
<#
    .SYNOPSIS
        Returns information about D365FO
        
    .DESCRIPTION
        Gets detailed information about application and platform
        
    .EXAMPLE
        PS C:\> Get-D365ProductInformation
        
        This will get product, platform and application version details for the environment
        
    .NOTES
        Tags: Build, Version, Reference, ProductVersion, ProductDetails, Product
        
        Author: Rasmus Andersen (@ITRasmus)
        
        The cmdlet wraps the call against a dll file that is shipped with Dynamics 365 for Finance & Operations.
        The call to the dll file gets all relevant product details for the environment.
        
        
#>
function Get-D365ProductInformation {
    [CmdletBinding()]
    param ()
    
    return Get-ProductInfoProvider
}